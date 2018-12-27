import Foundation
import PathKit

protocol ProcessRunning {
    /// Runs the process synchronously and returns the result.
    ///
    /// - Parameters:
    ///   - arguments: Command arguments.
    ///   - shouldBeTerminatedOnParentExit: When true, the task terminates when the current process exits.
    ///   - workingDirectoryPath: Directory where the task is executed from.
    ///   - env: Environment variables to be exposed to the task.
    ///   - onStdout: Called when new data if forwarded through the standard output.
    ///   - onStderr: Called when new data is forwarded through the standard error.
    /// - Returns: Task execution result.
    /// - Throws: A TaskError if the launch argument can't be found in the environment.
    func runSync(arguments: [String],
                 shouldBeTerminatedOnParentExit: Bool,
                 workingDirectoryPath: Path?,
                 env: [String: String]?,
                 onStdout: @escaping (Data) -> Void,
                 onStderr: @escaping (Data) -> Void) throws -> ProcessRunnerResult

    /// Runs the process asynchronously.
    ///
    /// - Parameters:
    ///   - arguments: Command arguments.
    ///   - shouldBeTerminatedOnParentExit: When true, the task terminates when the current process exits.
    ///   - workingDirectoryPath: Directory where the task is executed from.
    ///   - env: Environment variables to be exposed to the task.
    ///   - onStdout: Called when new data if forwarded through the standard output.
    ///   - onStderr: Called when new data is forwarded through the standard error.
    ///   - onCompletion: Called when the task completes.
    /// - Returns: Task execution result.
    /// - Throws: A TaskError if the launch argument can't be found in the environment.
    func runAsync(arguments: [String],
                  shouldBeTerminatedOnParentExit: Bool,
                  workingDirectoryPath: Path?,
                  env: [String: String]?,
                  onStdout: @escaping (Data) -> Void,
                  onStderr: @escaping (Data) -> Void,
                  onCompletion: @escaping (ProcessRunnerResult) -> Void) throws
}

/// Process runner result.
struct ProcessRunnerResult {
    /// Terminatino reason.
    let reason: Process.TerminationReason

    /// Exit code.
    let code: Int32
}

final class ProcessRunner: ProcessRunning {
    /// Instance to interact with the environment.
    private let environment: EnvironmentProtocol

    /// Initializes the task runner with its attributes.
    ///
    /// - Parameter environment: Instance to interact with the environment.
    init(environment: EnvironmentProtocol = Environment()) {
        self.environment = environment
    }

    /// Runs the process synchronously and returns the result.
    ///
    /// - Parameters:
    ///   - arguments: Command arguments.
    ///   - shouldBeTerminatedOnParentExit: When true, the task terminates when the current process exits.
    ///   - workingDirectoryPath: Directory where the task is executed from.
    ///   - env: Environment variables to be exposed to the task.
    ///   - onStdout: Called when new data if forwarded through the standard output.
    ///   - onStderr: Called when new data is forwarded through the standard error.
    /// - Returns: Task execution result.
    /// - Throws: A TaskError if the launch argument can't be found in the environment.
    func runSync(arguments: [String],
                 shouldBeTerminatedOnParentExit: Bool,
                 workingDirectoryPath: Path?,
                 env: [String: String]? = nil,
                 onStdout: @escaping (Data) -> Void,
                 onStderr: @escaping (Data) -> Void) throws -> ProcessRunnerResult {
        let queue = DispatchQueue(label: "io.tuist.process")
        let process = try self.process(arguments: arguments,
                                       shouldBeTerminatedOnParentExit: shouldBeTerminatedOnParentExit,
                                       workingDirectoryPath: workingDirectoryPath,
                                       env: env,
                                       queue: queue,
                                       onStdout: onStdout,
                                       onStderr: onStderr)

        process.launch()
        process.waitUntilExit()

        return queue.sync {
            ProcessRunnerResult(reason: process.terminationReason,
                                code: process.terminationStatus)
        }
    }

    /// Runs the process asynchronously.
    ///
    /// - Parameters:
    ///   - arguments: Command arguments.
    ///   - shouldBeTerminatedOnParentExit: When true, the task terminates when the current process exits.
    ///   - workingDirectoryPath: Directory where the task is executed from.
    ///   - env: Environment variables to be exposed to the task.
    ///   - onStdout: Called when new data if forwarded through the standard output.
    ///   - onStderr: Called when new data is forwarded through the standard error.
    ///   - onCompletion: Called when the task completes.
    /// - Returns: Task execution result.
    /// - Throws: A TaskError if the launch argument can't be found in the environment.
    func runAsync(arguments: [String],
                  shouldBeTerminatedOnParentExit: Bool,
                  workingDirectoryPath: Path?,
                  env: [String: String]?,
                  onStdout: @escaping (Data) -> Void,
                  onStderr: @escaping (Data) -> Void,
                  onCompletion: @escaping (ProcessRunnerResult) -> Void) throws {
        let queue = DispatchQueue(label: "io.tuist.process")
        let process = try self.process(arguments: arguments,
                                       shouldBeTerminatedOnParentExit: shouldBeTerminatedOnParentExit,
                                       workingDirectoryPath: workingDirectoryPath,
                                       env: env,
                                       queue: queue,
                                       onStdout: onStdout,
                                       onStderr: onStderr)

        process.launch()
        process.terminationHandler = { process in
            onCompletion(ProcessRunnerResult(reason: process.terminationReason,
                                             code: process.terminationStatus))
        }
    }

    // MARK: - Private

    /// Returns a process instance that runs the task.
    ///
    /// - Parameters:
    ///   - arguments: Command arguments.
    ///   - shouldBeTerminatedOnParentExit: When true, the task terminates when the current process exits.
    ///   - workingDirectoryPath: Directory where the task is executed from.
    ///   - env: Environment variables to be exposed to the task.
    ///   - queue: Queue to serialize output events.
    ///   - onStdout: Called when new data if forwarded through the standard output.
    ///   - onStderr: Called when new data is forwarded through the standard error.
    /// - Returns: Process instance.
    /// - Throws: A TaskError if the launch argument can't be found in the environment.
    private func process(arguments: [String],
                         shouldBeTerminatedOnParentExit: Bool,
                         workingDirectoryPath: Path?,
                         env: [String: String]?,
                         queue: DispatchQueue,
                         onStdout: @escaping (Data) -> Void,
                         onStderr: @escaping (Data) -> Void) throws -> Process {
        precondition(arguments.count > 0 && !arguments[0].isEmpty, "At least one argument is required")

        guard let launchpath = self.lookupExecutable(arguments[0]) else {
            throw ShellError.missingExecutable(name: arguments[0])
        }

        let process = Process()
        process.launchPath = launchpath.string
        process.arguments = Array(arguments.dropFirst())

        if shouldBeTerminatedOnParentExit {
            // This is for terminating subprocesses when the parent process exits.
            // See https://github.com/Carthage/ReactiveTask/issues/3 for the details.
            let selector = Selector(("setStartsNewProcessGroup:"))
            if process.responds(to: selector) {
                process.perform(selector, with: false as NSNumber)
            }
        }

        if let workingDirectoryPath = workingDirectoryPath {
            process.currentDirectoryPath = workingDirectoryPath.string
        }

        if let env = env {
            process.environment = env
        }

        let outputPipe = Pipe()
        process.standardOutput = outputPipe

        let errorPipe = Pipe()
        process.standardError = errorPipe

        outputPipe.fileHandleForReading.readabilityHandler = { handler in
            queue.async { onStdout(handler.availableData) }
        }

        errorPipe.fileHandleForReading.readabilityHandler = { handler in
            queue.async { onStderr(handler.availableData) }
        }

        return process
    }

    /// It looks up an executable in the user environment.
    ///
    /// - Parameter name: Executable to be looked up.
    /// - Returns: Executable path if found.
    private func lookupExecutable(_ name: String) -> Path? {
        let searchPaths = environment.searchPaths()
        return environment.lookupExecutable(name: name, in: searchPaths)
    }
}

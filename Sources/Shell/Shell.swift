import Foundation
import class Foundation.ProcessInfo
import PathKit

/// Class tu run commands in the system.
public class Shell {
    /// Process runner.
    let runner: ProcessRunning

    /// Public constructor.
    public convenience init() {
        self.init(runner: ProcessRunner())
    }

    /// Initializes the shell with its attributes.
    ///
    /// - Parameter runner: Instance to run the commands in the system.
    init(runner: ProcessRunning) {
        self.runner = runner
    }

    /// Runs a given command and returns its result synchronously.
    ///
    /// - Parameter arguments: Command arguments.
    /// - Returns: Command result.
    /// - Throws: An error if the task cannot be launched.
    public func sync(_ arguments: [String]) throws -> ShellResult {
        return try self.sync(arguments,
                             shouldBeTerminatedOnParentExit: true,
                             workingDirectoryPath: nil,
                             env: nil,
                             onStdout: nil,
                             onStderr: nil)
    }

    /// Runs a given command and returns its result synchronously.
    ///
    /// - Parameters:
    ///   - arguments: Command arguments.
    ///   - shouldBeTerminatedOnParentExit: When true, it kills the task when the current process terminates.
    ///   - workingDirectoryPath: Directory the process should be run from.
    ///   - env: Environment variables to be exposed to the command.
    ///   - onStdout: Closure to send the standard output through.
    ///   - onStderr: Closure to send the standard error through.
    /// - Returns: Command result.
    /// - Throws: An error if the task cannot be launched.
    public func sync(_ arguments: [String],
                     shouldBeTerminatedOnParentExit: Bool,
                     workingDirectoryPath: Path?,
                     env: [String: String]?,
                     onStdout: ((String) -> Void)?,
                     onStderr: ((String) -> Void)?) throws -> ShellResult {
        let onStdoutData: (Data) -> Void = { data in
            if let onStdout = onStdout, let string = String(data: data, encoding: .utf8) { onStdout(string) }
        }
        let onStderrData: (Data) -> Void = { data in
            if let onStderr = onStderr, let string = String(data: data, encoding: .utf8) { onStderr(string) }
        }
        let result = try self.runner.runSync(arguments: arguments,
                                             shouldBeTerminatedOnParentExit: shouldBeTerminatedOnParentExit,
                                             workingDirectoryPath: workingDirectoryPath,
                                             env: env,
                                             onStdout: onStdoutData,
                                             onStderr: onStderrData)
        return ShellResult(stdout: nil, stderr: nil, reason: result.reason, code: result.code)
    }

    /// Runs a given command and notifies about its completion asynchronously.
    ///
    /// - Parameters:
    ///   - arguments: Command arguments.
    ///   - onCompletion: Closure to notify the completion of the task.
    /// - Throws: An error if the task cannot be launched.
    public func async(_ arguments: [String], onCompletion: @escaping (ShellResult) -> Void) throws {
        try self.async(arguments,
                       shouldBeTerminatedOnParentExit: true,
                       workingDirectoryPath: nil,
                       env: nil,
                       onStdout: nil,
                       onStderr: nil,
                       onCompletion: onCompletion)
    }

    /// Runs a given command and notifies about its completion asynchronously.
    ///
    /// - Parameters:
    ///   - arguments: Command arguments.
    ///   - shouldBeTerminatedOnParentExit: When true, it kills the task when the current process terminates.
    ///   - workingDirectoryPath: Directory the process should be run from.
    ///   - env: Environment variables to be exposed to the command.
    ///   - onStdout: Closure to send the standard output through.
    ///   - onStderr: Closure to send the standard error through.
    ///   - onCompletion: Closure to notify the completion of the task.
    /// - Throws: An error if the task cannot be launched.
    public func async(_ arguments: [String],
                      shouldBeTerminatedOnParentExit: Bool,
                      workingDirectoryPath: Path?,
                      env: [String: String]?,
                      onStdout: ((String) -> Void)?,
                      onStderr: ((String) -> Void)?,
                      onCompletion: @escaping (ShellResult) -> Void) throws {
        let onStdoutData: (Data) -> Void = { data in
            if let onStdout = onStdout, let string = String(data: data, encoding: .utf8) { onStdout(string) }
        }
        let onStderrData: (Data) -> Void = { data in
            if let onStderr = onStderr, let string = String(data: data, encoding: .utf8) { onStderr(string) }
        }
        try self.runner.runAsync(arguments: arguments,
                                 shouldBeTerminatedOnParentExit: shouldBeTerminatedOnParentExit,
                                 workingDirectoryPath: workingDirectoryPath,
                                 env: env,
                                 onStdout: onStdoutData,
                                 onStderr: onStderrData,
                                 onCompletion: { result in
                                     onCompletion(ShellResult(stdout: nil,
                                                              stderr: nil,
                                                              reason: result.reason,
                                                              code: result.code))
        })
    }

    /// Runs the given command and returns the captured output.
    ///
    /// - Parameter arguments: Command arguments.
    /// - Returns: Result of running the command.
    /// - Throws: An error if the command cannot be run.
    public func capture(_ arguments: [String]) throws -> ShellResult {
        return try self.capture(arguments, workingDirectoryPath: nil, env: nil)
    }

    /// Runs the given command and returns the captured output.
    ///
    /// - Parameters:
    ///   - arguments: Command arguments.
    ///   - workingDirectoryPath: Working directory to run the command from.
    ///   - env: Environment variables to be exposed to the command.
    /// - Returns: Result of running the command.
    /// - Throws: An error if the command cannot be run.
    public func capture(_ arguments: [String],
                        workingDirectoryPath: Path?,
                        env: [String: String]?) throws -> ShellResult {
        var output = ""
        var error = ""

        let result = try self.runner.runSync(arguments: arguments,
                                             shouldBeTerminatedOnParentExit: true,
                                             workingDirectoryPath: workingDirectoryPath,
                                             env: env,
                                             onStdout: { stdout in
                                                 if let string = String(data: stdout, encoding: .utf8) {
                                                     output.append(string)
                                                 }
                                             },
                                             onStderr: { stderror in
                                                 if let string = String(data: stderror, encoding: .utf8) {
                                                     error.append(string)
                                                 }
        })
        return ShellResult(stdout: error,
                           stderr: error,
                           reason: result.reason,
                           code: result.code)
    }
}

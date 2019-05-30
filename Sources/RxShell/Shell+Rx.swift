import Foundation
import PathKit
import RxSwift
import Shell

/// Shell event throw through the observable stream.
///
/// - stdout: Standard output.
/// - stderr: Standard error.
public enum ShellEvent {
    case stdout(String)
    case stderr(String)
}

/// Type that serves to concatenate the standard output and error from a task.
public class ShellOutput {
    /// The accumulated standard output.
    public internal(set) var stdout: String

    /// The accumulated standard error.
    public internal(set) var stderr: String

    /// Initializes the shell output with its attributes.
    ///
    /// - Parameters:
    ///   - stdout: Standard output.
    ///   - stderr: Standard error.
    init(stdout: String = "", stderr: String = "") {
        self.stdout = stdout
        self.stderr = stderr
    }

    /// Returns a new instance of the output trimming the whitespaces and newlines in both ends of the standard output and error.
    ///
    /// - Returns: Instance of ShellOutput.
    func chomp() -> ShellOutput {
        return ShellOutput(stdout: stdout.trimmingCharacters(in: .whitespacesAndNewlines),
                           stderr: stderr.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}

extension Observable where Element == ShellEvent {
    /// Concatenates the standard output and error into a single ShellOutput instance.
    ///
    /// - Returns: ShellOutput instance with all the standard output and error.
    public func collect() -> Observable<ShellOutput> {
        return reduce(ShellOutput()) { (output, event) -> ShellOutput in
            switch event {
            case let .stderr(stderr):
                output.stderr.append(contentsOf: stderr)
            case let .stdout(stdout):
                output.stdout.append(contentsOf: stdout)
            }
            return output
        }.map { $0.chomp() }
    }
}

extension Shell {
    /// Returns an observable that runs a system task with the given arguments.
    ///
    /// - Parameter arguments: Task arguments.
    /// - Returns: Observable to run the task.
    public func run(_ arguments: [String]) -> Observable<ShellEvent> {
        return run(arguments,
                   shouldBeTerminatedOnParentExit: true,
                   workingDirectoryPath: nil,
                   env: nil)
    }

    /// Returns an observable that runs a system task with the given arguments.
    ///
    /// - Parameters:
    ///   - arguments: Task arguments.
    ///   - shouldBeTerminatedOnParentExit: When true, the process is terminated if the process that triggers the task gets terminated.
    ///   - workingDirectoryPath: Working directory from which execute the task.
    ///   - env: Environment variables.
    /// - Returns: Observable to run the task.
    public func run(_ arguments: [String],
                    shouldBeTerminatedOnParentExit: Bool,
                    workingDirectoryPath: Path?,
                    env: [String: String]?) -> Observable<ShellEvent> {
        return Observable<ShellEvent>.create { (subscriber) -> Disposable in
            let process = self.async(arguments,
                                     shouldBeTerminatedOnParentExit: shouldBeTerminatedOnParentExit,
                                     workingDirectoryPath: workingDirectoryPath,
                                     env: env,
                                     onStdout: { stdout in
                                         subscriber.onNext(.stdout(stdout))
                                     }, onStderr: { stderr in
                                         subscriber.onNext(.stderr(stderr))
                                     }, onCompletion: { result in
                                         switch result {
                                         case let .failure(error):
                                             subscriber.onError(error)
                                         case .success:
                                             subscriber.onCompleted()
                                         }
            })
            return Disposables.create {
                process?.terminate()
            }
        }
    }
}

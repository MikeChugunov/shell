import Foundation

public struct ShellError: Error, CustomStringConvertible {
    /// Process runner error
    public let processError: ProcessRunnerError

    /// Standard error output
    public let stderr: String?

    /// Initializes the error with its attributes.
    ///
    /// - Parameters:
    ///   - processError: Process runner error
    ///   - stderr: Standard error output
    public init(processError: ProcessRunnerError, stderr: String? = nil) {
        self.processError = processError
        self.stderr = stderr
    }

    /// Error description.
    public var description: String {
        if let stderr = stderr {
            return stderr
        } else {
            return processError.description
        }
    }
}

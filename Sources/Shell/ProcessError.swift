import Foundation

public enum ShellError: Error, CustomStringConvertible {
    /// Thrown when an executable can't be found in the user PATH.
    case missingExecutable(name: String)

    /// Thrown when a command completed unsuccessfully
    case failed(code: Int32, stderr: String?)

    /// Error descriptino.
    public var description: String {
        switch self {
        case let .missingExecutable(name):
            return "Couldn't find the executable with name '\(name)' in the user PATH"
        case let .failed(code, stderr):
            if let stderr = stderr {
                return "Command exited with code \(code) and error: \(stderr)"
            } else {
                return "Command exited with code \(code)"
            }
        }
    }
}

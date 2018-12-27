import Foundation

public struct ShellResult {
    /// Standard output.
    public let stdout: String?

    /// Standard error.
    public let stderr: String?

    /// Terminatino reason.
    public let reason: Process.TerminationReason

    /// Exit code.
    public let code: Int32

    public func throwIfFailed() throws {
        if code != 0 {
            throw ShellError.failed(code: code, stderr: stderr)
        }
    }
}

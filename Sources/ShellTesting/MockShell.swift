import Foundation
import PathKit
import Shell

public extension Shell {
    /// Returns a mock instance for testing purposes.
    ///
    /// - Returns: Mock instance of shell.
    public static func mock() -> MockShell {
        return MockShell(runner: MockProcessRunner())
    }
}

public final class MockShell: Shell {
    /// Stubs the given command to succeed.
    ///
    /// - Parameter arguments: Command arguments.
    public func succeed(_ arguments: [String]) {
        stub(arguments,
             code: 0)
    }

    /// Stubs the given command to fail.
    ///
    /// - Parameters:
    ///   - arguments: Command arguments.
    ///   - stderr: Stub standard error output.
    ///   - code: Stub exit code.
    public func error(_ arguments: [String], stderr: [String], code: Int32 = 1) {
        stub(arguments,
             stder: stderr,
             code: code)
    }

    /// Stubs the given command.
    ///
    /// - Parameters:
    ///   - arguments: Command arguments.
    ///   - shouldBeTerminatedOnParentExit: True if the command should be terminated when the current process exists.
    ///   - workingDirectoryPath: Directory to run the command from.
    ///   - env: Environment to be exposed to the command.
    ///   - stdout: Stub standard output.
    ///   - stder: Stub standard error output.
    ///   - code: Stub exit code.
    public func stub(_ arguments: [String],
                     shouldBeTerminatedOnParentExit: Bool = true,
                     workingDirectoryPath: Path? = nil,
                     env: [String: String]? = nil,
                     stdout: [String] = [],
                     stder: [String] = [],
                     code: Int32 = 0) {
        (runner as! MockProcessRunner).stub(arguments: arguments,
                                            shouldBeTerminatedOnParentExit: shouldBeTerminatedOnParentExit,
                                            workingDirectoryPath: workingDirectoryPath,
                                            env: env,
                                            stdout: stdout,
                                            stder: stder,
                                            code: code)
    }
}

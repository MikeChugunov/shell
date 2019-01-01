import Foundation
import XCTest

@testable import Shell

final class ShellErrorTests: XCTestCase {
    func test_description_when_noStderr() {
        let processError: ProcessRunnerError = .missingExecutable("invalid")
        let subject = ShellError(processError: processError)

        XCTAssertEqual(subject.description, processError.description)
    }

    func test_description() {
        let processError: ProcessRunnerError = .missingExecutable("invalid")
        let subject = ShellError(processError: processError,
                                 stderr: "stderr")

        XCTAssertEqual(subject.description, "stderr")
    }
}

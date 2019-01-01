import Foundation
import XCTest

@testable import Shell

final class ProcessRunnerErrorTests: XCTestCase {
    func test_description_when_shell_and_exit() {
        let subject = ProcessRunnerError.shell(reason: .exit, code: 1)
        XCTAssertEqual(subject.description, "The process errored with code 1")
    }

    func test_description_when_shell_and_interruption() {
        let subject = ProcessRunnerError.shell(reason: .uncaughtSignal, code: 1)
        XCTAssertEqual(subject.description, "The process was interrupted with code 1")
    }

    func test_description_when_missingExecutable() {
        let subject = ProcessRunnerError.missingExecutable("invalid")
        XCTAssertEqual(subject.description, "The executable with name 'invalid' was not found")
    }
}

import Foundation
import XCTest

@testable import Shell

final class ShellErrorTests: XCTestCase {
    func test_description() {
        XCTAssertEqual(ShellError.missingExecutable(name: "executable").description,
                       "Couldn't find the executable with name 'executable' in the user PATH")
        XCTAssertEqual(ShellError.failed(code: 33, stderr: "error").description,
                       "Command exited with code 33 and error: error")
        XCTAssertEqual(ShellError.failed(code: 33, stderr: nil).description,
                       "Command exited with code 33")
    }
}

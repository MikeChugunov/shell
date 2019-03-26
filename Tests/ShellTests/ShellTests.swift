import Foundation
import PathKit
import Result
import XCTest

@testable import Shell

final class ShellTests: XCTestCase {
    var subject: Shell!

    override func setUp() {
        subject = Shell()
    }

    func test_lookupExecutable() {
        let got = Shell.lookupExecutable("xcode-select")
        XCTAssertEqual(got, Path("/usr/bin/xcode-select"))
    }

    func test_sync() {
        var stdout: [String] = []
        let got = subject.sync(["echo", "test"],
                               shouldBeTerminatedOnParentExit: true,
                               workingDirectoryPath: nil,
                               env: nil,
                               onStdout: { stdout.append($0) },
                               onStderr: nil)
        XCTAssertNil(got.error)
        XCTAssertEqual(stdout, ["test\n"])
    }

    func test_sync_when_command_fails() {
        var stderr: [String] = []

        let got = subject.sync(["xcrun", "invalid"],
                               shouldBeTerminatedOnParentExit: true,
                               workingDirectoryPath: nil,
                               env: nil,
                               onStdout: nil) { stderr.append($0) }

        XCTAssertNotNil(got.error)
        let expected = "xcrun: error: unable to find utility \"invalid\", not a developer tool or in PATH\n"
        XCTAssertEqual(stderr, [expected])
    }

    func test_async() {
        var stdout: [String] = []
        var result: Result<Void, ShellError>!

        let expectation = XCTestExpectation(description: #function)
        subject.async(["echo", "test"],
                      shouldBeTerminatedOnParentExit: true,
                      workingDirectoryPath: nil,
                      env: nil,
                      onStdout: { stdout.append($0) },
                      onStderr: nil,
                      onCompletion: {
                          expectation.fulfill()
                          result = $0
        })
        wait(for: [expectation], timeout: 1)
        XCTAssertNil(result.error)
        XCTAssertEqual(stdout, ["test\n"])
    }

    func test_async_when_command_fails() {
        var stderr: [String] = []
        var result: Result<Void, ShellError>!

        let expectation = XCTestExpectation(description: #function)
        subject.async(["xcrun", "invalid"],
                      shouldBeTerminatedOnParentExit: true,
                      workingDirectoryPath: nil,
                      env: nil,
                      onStdout: nil,
                      onStderr: { stderr.append($0) },
                      onCompletion: {
                          result = $0
                          expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10)
        XCTAssertNotNil(result.error)
        let expected = "xcrun: error: unable to find utility \"invalid\", not a developer tool or in PATH\n"
        XCTAssertEqual(stderr, [expected])
    }

    func test_capture() {
        let got = subject.capture(["echo", "test"],
                                  workingDirectoryPath: nil,
                                  env: nil)
        XCTAssertEqual(got.value, "test\n")
    }

    func test_capture_when_command_fails() {
        let got = subject.capture(["xcrun", "invalid"],
                                  workingDirectoryPath: nil,
                                  env: nil)
        let errorMessage = "xcrun: error: unable to find utility \"invalid\", not a developer tool or in PATH\n"
        let expected = ShellError(processError: .shell(reason: .exit, code: 72),
                                  stderr: errorMessage)
        XCTAssertEqual(got.error, expected)
    }

    func test_succeeds() {
        XCTAssertTrue(subject.succeeds(["which", "xcodebuild"]))
        XCTAssertFalse(subject.succeeds(["which", "invalid"]))
    }
}

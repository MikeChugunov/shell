import Foundation
import PathKit
import XCTest

@testable import Shell

final class EnvironmentTests: XCTestCase {
    var subject: Environment!

    override func setUp() {
        super.setUp()
        subject = Environment()
    }

    func test_searchPaths() {
        let path = "/test/path:relative/path"
        let current = Path("/base")
        let got = subject.searchPaths(pathString: path,
                                      currentWorkingDirectory: current)

        XCTAssertEqual(got.count, 2)
        XCTAssertEqual(got.first, Path("/test/path"))
        XCTAssertEqual(got.last, Path("/base/relative/path"))
    }

    func test_lookupExecutable_when_aNameIsGiven() {
        let paths = subject.searchPaths()
        let got = subject.lookupExecutable(name: "xcrun",
                                           in: paths)
        XCTAssertNotNil(got)
    }

    func test_lookupExecutable_when_anAbsolutePathIsGiven() {
        let paths = subject.searchPaths()
        let got = subject.lookupExecutable(name: "/usr/bin/xcrun",
                                           in: paths)
        XCTAssertNotNil(got)
    }

    func test_lookupExecutable_when_theExecutableDoesntExist() {
        let paths = subject.searchPaths()
        let got = subject.lookupExecutable(name: "invalid",
                                           in: paths)
        XCTAssertNil(got)
    }
}

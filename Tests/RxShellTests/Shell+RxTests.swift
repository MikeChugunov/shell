import Foundation
import RxBlocking
import RxSwift
import Shell
import XCTest

@testable import RxShell

final class ShellRxTests: XCTestCase {
    var subject: Shell!

    override func setUp() {
        subject = Shell()
    }

    func test_run() throws {
        let got = try subject.run(["which", "open"],
                                  shouldBeTerminatedOnParentExit: false,
                                  workingDirectoryPath: nil,
                                  env: nil)
            .collect()
            .toBlocking()
            .first()
        XCTAssertEqual(got?.stdout, "/usr/bin/open")
    }
}

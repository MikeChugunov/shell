import Foundation
import PathKit
import Result
import Shell

final class MockProcessRunner: ProcessRunning {
    struct StubbedCommand: Hashable {
        let arguments: [String]
        let shouldBeTerminatedOnParentExit: Bool
        let workingDirectoryPath: Path?
        let env: [String: String]?
    }

    struct StubOutput {
        let stdout: [String]
        let stderr: [String]
        let code: Int32
    }

    var stubs: [StubbedCommand: StubOutput] = [:]

    func stub(arguments: [String],
              shouldBeTerminatedOnParentExit: Bool = true,
              workingDirectoryPath: Path? = nil,
              env: [String: String]? = nil,
              stdout: [String] = [],
              stder: [String] = [],
              code: Int32 = 0) {
        stubs[StubbedCommand(arguments: arguments,
                             shouldBeTerminatedOnParentExit: shouldBeTerminatedOnParentExit,
                             workingDirectoryPath: workingDirectoryPath,
                             env: env)] = StubOutput(stdout: stdout, stderr: stder, code: code)
    }

    func runSync(arguments: [String],
                 shouldBeTerminatedOnParentExit: Bool,
                 workingDirectoryPath: Path?,
                 env _: [String: String]?,
                 onStdout: @escaping (Data) -> Void,
                 onStderr: @escaping (Data) -> Void) -> Result<Void, ProcessRunnerError> {
        let command = arguments.joined(separator: " ")
        guard let stub = stubs[StubbedCommand(arguments: arguments,
                                              shouldBeTerminatedOnParentExit: shouldBeTerminatedOnParentExit,
                                              workingDirectoryPath: workingDirectoryPath,
                                              env: nil)] else {
            onStderr("command '\(command)' not stubbed".data(using: .utf8)!)
            return .failure(.shell(reason: .exit, code: 1))
        }

        stub.stdout.forEach({ onStdout($0.data(using: .utf8)!) })
        stub.stderr.forEach({ onStderr($0.data(using: .utf8)!) })
        if stub.code == 0 {
            return .success(())
        } else {
            return .failure(.shell(reason: .exit, code: stub.code))
        }
    }

    func runAsync(arguments: [String],
                  shouldBeTerminatedOnParentExit: Bool,
                  workingDirectoryPath: Path?,
                  env _: [String: String]?,
                  onStdout: @escaping (Data) -> Void,
                  onStderr: @escaping (Data) -> Void,
                  onCompletion: @escaping (Result<Void, ProcessRunnerError>) -> Void) {
        let command = arguments.joined(separator: " ")
        guard let stub = stubs[StubbedCommand(arguments: arguments,
                                              shouldBeTerminatedOnParentExit: shouldBeTerminatedOnParentExit,
                                              workingDirectoryPath: workingDirectoryPath,
                                              env: nil)] else {
            onStderr("command '\(command)' not stubbed".data(using: .utf8)!)
            onCompletion(.failure(.shell(reason: .exit, code: 1)))
            return
        }

        stub.stdout.forEach({ onStdout($0.data(using: .utf8)!) })
        stub.stderr.forEach({ onStderr($0.data(using: .utf8)!) })
        if stub.code == 0 {
            return onCompletion(.success(()))
        } else {
            return onCompletion(.failure(.shell(reason: .exit, code: stub.code)))
        }
    }
}

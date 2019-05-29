import Foundation
import Shell
import RxSwift
import PathKit

public enum ShellEvent {
    case stdout(String)
    case stderr(String)
}

extension Shell {
    
    public func run(_ arguments: [String],
                      shouldBeTerminatedOnParentExit: Bool,
                      workingDirectoryPath: Path?,
                      env: [String: String]?,
                      onStdout: ((String) -> Void)?,
                      onStderr: ((String) -> Void)?) ->  Observable<ShellEvent> {
        return Observable<ShellEvent>.create { (subscriber) -> Disposable in
            
        }
    }
    
}

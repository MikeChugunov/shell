# Changelog

Please, check out guidelines: https://keepachangelog.com/en/1.0.0/

## next version

## 2.1.0

### Added

- **RxSwift** package by @pepibumur.

## 2.0.3

### Fixed

- Carthage dependency to PathKit by @pepibumur.

## 2.0.2

### Fixed

- Remove residual print by @pepibumur.

## 2.0.1

### Changed

- Bump PathKit version to 1.0.0 https://github.com/tuist/shell/pull/11 by @pepibumur.

## 2.0.0

### Added

- **Breaking:** Swift 5 support https://github.com/tuist/shell/pull/10 by @pepibumur.

## 1.2.1

### Fixed

- File handlers not getting deallocated after the task completes https://github.com/tuist/shell/pull/9 by @pepibumur.

## 1.2.0

### Fixed

- Race condition in `ProcessRunner` https://github.com/tuist/shell/pull/8 by @pepibumur.

### Added

- `Shell.succeeds` method https://github.com/tuist/shell/pull/7 by @pepibumur.

### Changed

## 1.1.0

### Changed

- Bump Result to 4.1.0 https://github.com/tuist/shell/pull/6 by @pepibumur.

## 1.0.2

### Added

- Tests https://github.com/tuist/shell/pull/5 by @pepibumur.

### Removed

- **Breaking** Remove throws that are not required https://github.com/tuist/shell/pull/4 by @pepibumur.

## 1.0.1

### Fixed

- Shell returning an error even if the command succeeded by @pepibumur.

## 1.0.0

### Changed

- **Breaking** Refactor API to use the [Result](https://github.com/antitypical/Result) type instead of throws https://github.com/tuist/shell/pull/3 by @pepibumur.

## 0.3.2

### Fixed

- Remove `@testable` imports from ShellTesting by @pepibumur.

## 0.3.1

### Added

- `ShellTesting.podspec` by @pepibumur.

## 0.3.0

### Added

- Add `Shell.lookupExecutable` method https://github.com/tuist/shell/pull/2 by @pepibumur.

## 0.2.0

### Changed

- Make `MockShell` methods public https://github.com/tuist/shell/pull/1

## 0.1.0

- 🎉 First version of the library

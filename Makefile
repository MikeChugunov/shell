release-check:
	swift build
	swift test
	xcodebuild clean build -scheme Shell -project Shell-Carthage.xcodeproj
	xcodebuild clean build -scheme ShellTesting -project Shell-Carthage.xcodeproj
pod-push:
	bundle exec pod trunk push --allow-warnings --verbose Shell.podspec
	bundle exec pod trunk push --allow-warnings --verbose ShellTesting.podspec
	bundle exec pod trunk push --allow-warnings --verbose RxShell.podspec
carthage-archive:
	carthage build --no-skip-current --platform macOS
	carthage archive Shell
	carthage archive ShellTesting
	carthage archive RxShell
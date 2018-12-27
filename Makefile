release-check:
	swift build
	swift test
	xcodebuild clean build -scheme Shell -project Shell-Carthage.xcodeproj
	xcodebuild clean build -scheme ShellTesting -project Shell-Carthage.xcodeproj
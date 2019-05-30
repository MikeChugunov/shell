Pod::Spec.new do |s|
  s.name             = "RxShell"
  s.version          = "2.1.2"
  s.summary          = "A extension for Shell that adds a reactive interface with RxSwift"
  s.homepage         = "https://github.com/tuist/shell"
  s.social_media_url = 'https://twitter.com/tuist'
  s.license          = 'MIT'
  s.source           = { :git => "https://github.com/tuist/shell.git", :tag => s.version.to_s }
  s.requires_arc = true
  s.authors = "Tuist"
  s.swift_version = "5.0"

  s.osx.deployment_target = '10.10'

  s.source_files = "Sources/RxShell/**/*.{swift}"

  s.dependency "Shell", "2.1.2"
  s.dependency "RxSwift", "5.0.0"
end
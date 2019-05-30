Pod::Spec.new do |s|
  s.name             = "Shell"
  s.version          = "2.0.3"
  s.summary          = "Shell is a µ-library written Swift to run system commands"
  s.homepage         = "https://github.com/tuist/shell"
  s.social_media_url = 'https://twitter.com/tuist'
  s.license          = 'MIT'
  s.source           = { :git => "https://github.com/tuist/shell.git", :tag => s.version.to_s }
  s.requires_arc = true
  s.authors = "Tuist"
  s.swift_version = "5.0"

  s.osx.deployment_target = '10.10'

  s.source_files = "Sources/Shell/**/*.{swift}"

  s.dependency "PathKit", "1.0.0"
end
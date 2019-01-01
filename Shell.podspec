Pod::Spec.new do |s|
  s.name             = "Shell"
  s.version          = "0.3.2"
  s.summary          = "Shell is a µ-library written Swift to run system commands"
  s.homepage         = "https://github.com/tuist/shell"
  s.social_media_url = 'https://twitter.com/pepibumur'
  s.license          = 'MIT'
  s.source           = { :git => "https://github.com/tuist/shell.git", :tag => s.version.to_s }
  s.requires_arc = true
  s.authors = "Tuist"

  s.osx.deployment_target = '10.10'

  s.source_files = "Sources/Shell/**/*.{swift}"

  s.dependency "PathKit", "0.9.2"
  s.dependency "Result", "4.0.1"
end
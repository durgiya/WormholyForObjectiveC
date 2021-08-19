Pod::Spec.new do |s|
  s.name         = "WormholyForObjectiveC"
  s.version      = "1.0.0"
  s.summary      = "Network debugging made easy，This network debugging tool is developed based on the swift version of Wormholy."
  s.description  = <<-DESC
    Start debugging iOS network calls like a wizard, without extra code! Wormholy makes debugging quick and reliable.
  DESC
  s.homepage     = "https://github.com/durgiya/WormholyForObjectiveC"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "durgiya" => "durgiya@qq.com" }
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/durgiya/WormholyForObjectiveC", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*.{h,m}"
  s.public_header_files = "Sources/**/*.h"
  s.resource_bundles = {
    'Wormholy' => ['Sources/**/*.storyboard', 'Sources/**/*.xib', 'Sources/**/*.{css,js}']
  }
  s.frameworks  = "Foundation"
end

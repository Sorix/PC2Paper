Pod::Spec.new do |s|
  s.name             = "PC2Paper"
  s.summary          = "PC2Paper API client"
  s.version          = "0.1"
  s.homepage         = "https://github.com/sorix/PC2Paper"
  s.license          = 'MIT'
  s.author           = { "Vasily Ulianov" => "vasily@me.com" }
  s.source           = {
    :git => "https://github.com/sorix/PC2Paper.git",
    :tag => s.version.to_s
  }

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '3.0'

  s.source_files = 'Source/**/*.swift'

  s.ios.frameworks = 'Foundation', 'CloudKit', 'CoreData'
  s.osx.frameworks = 'Foundation', 'CloudKit', 'CoreData'

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
  s.documentation_url = 'http://cocoadocs.org/docsets/CloudCore/'
end

Pod::Spec.new do |s|

  s.name             = "Core"
  s.version          = "0.0.1"
  s.summary          = "This is the Core-Library for the HTWDresden iOS-App."

  s.description      = <<-DESC
                       DESC

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'

  s.requires_arc = true

  s.source_files = 'Core/Source/**/*'

  s.frameworks = 'UIKit'
  s.dependency 'Alamofire'
  s.dependency 'ObjectMapper'
  s.dependency 'SwiftString'
  
end

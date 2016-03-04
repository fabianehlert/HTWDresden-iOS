Pod::Spec.new do |s|
  s.name             = "HTWGrades"
  s.version          = "0.0.1"
  s.summary          = "A short description of HTWGrades."

  s.description      = <<-DESC
                       DESC

  s.homepage         = "https://github.com/<GITHUB_USERNAME>/HTWGrades"
  s.license          = 'MIT'
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/HTWGrades.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'HTWGrades/Pod/**/*'
  s.resource_bundles = {
    'HTWGrades' => ['Pod/Assets/*.png']
  }
  
  s.dependency 'ObjectMapper'
  s.dependency 'Alamofire'
end

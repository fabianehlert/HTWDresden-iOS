Pod::Spec.new do |s|
  s.name             = "Grades"
  s.version          = "0.0.1"
  s.summary          = "A short description of Grades."

  s.description      = <<-DESC
                       DESC

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'

  s.requires_arc = true

  s.source_files = 'Grades/Pod/**/*'
  s.resource_bundles = {
    'HTWGrades' => ['Grades/Pod/Assets/*.png']
  }
  
  s.dependency 'Core'
end

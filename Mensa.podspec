Pod::Spec.new do |s|
  s.name             = "Mensa"
  s.version          = "0.0.1"
  s.summary          = "A short description of Mensa."

  s.description      = <<-DESC
                       DESC


  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'

  s.requires_arc = true

  s.source_files = 'Mensa/Source/**/*'
  s.resource_bundles = {
    'Mensa' => ['Mensa/Assets/*.png']
  }

  s.dependency 'Core'
end

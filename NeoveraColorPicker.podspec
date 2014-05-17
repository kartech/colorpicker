Pod::Spec.new do |s|
  s.name = 'NeoveraColorPicker'
  s.version = '1.0'
  s.summary = 'Neovera Color Picker'
  s.homepage = 'http://kartech.github.com/colorpicker/'
  s.license  = 'Apache 2'
  s.author = 'Neovera'
  s.source = {
    :git => 'https://github.com/kartech/colorpicker.git',
    :commit => '7e40a227f40d3e7328deb5e2f9953f85b6dd095c'
  }
  s.platform = :ios, '5.0'
  s.source_files =  'Source/'
  s.resources    = 'Source/*.{xib}', 'Source/colorPicker.bundle'
  s.frameworks = 'UIKit', 'QuartzCore'
  s.requires_arc = true
end

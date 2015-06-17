Pod::Spec.new do |s|
  s.name = 'AlphaColorPicker'
  s.version = '0.0.1'
  s.summary = 'Alpha Color Picker'
  s.homepage = 'http://github.com/panyam/colorpicker/'
  s.license = "Apache License, Version 2.0"
  s.author = 'Neovera'
  s.source       = { :git => "https://github.com/panyam/colorpicker.git", :tag=> "v0.0.1" }
  s.platform = :ios, '5'
  s.source_files =  'Source/'
  s.resources    = 'Source/*.{xib}', 'Source/colorPicker.bundle'
  s.frameworks = 'UIKit', 'QuartzCore'
  s.requires_arc = true
end

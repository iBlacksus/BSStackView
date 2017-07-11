Pod::Spec.new do |spec|
  spec.name         = 'BSStackView'
  spec.version      = '1.0.0'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage     = 'https://github.com/iBlacksus/BSStackView'
  spec.authors      = { 'iBlacksus' => 'iblacksus@gmail.com' }
  spec.summary      = 'StackView like card interface'
  spec.source       = { :git => 'https://github.com/iBlacksus/BSStackView.git', :tag => '1.0.0' }
  spec.source_files = 'BSStackView/**/*'
  spec.framework    = 'SystemConfiguration'
  spec.ios.deployment_target  = '8.0'
  spec.ios.framework  = 'UIKit'
end
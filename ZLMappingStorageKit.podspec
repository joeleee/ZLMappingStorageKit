Pod::Spec.new do |s|

  s.name         = "ZLMappingStorageKit"
  s.version      = "v0.0.1"
  s.summary      = "RestKit similar mapping function module separate implementation."

  s.description = "RestKit similar mapping function module separate implementation. Decoupling the mapping logic without network libraries and CoreData decoupling. More detailed description added later."

  s.homepage     = "https://github.com/zhuocheng/ZLMappingStorageKit"
  s.license      = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }

  s.author           = { "李卓成" => "zhuocheng.lee@gmail.com" }
  s.social_media_url = "http://www.renren.com/428049345/profile"

  s.platform              = :ios, '5.0'
  s.ios.deployment_target = '5.0'

  s.source       = { :git => "https://github.com/zhuocheng/ZLMappingStorageKit.git", :tag => "v0.0.1" }
  s.source_files = 'ZLMappingStorageKit/*.{h,m}'
  s.requires_arc = true

end

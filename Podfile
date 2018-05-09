# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/aliyun/aliyun-specs.git'

platform :ios, '8.0'
use_frameworks!

target 'KZWFoundation' do

    pod 'Masonry'
    pod 'MJRefresh'
    pod 'AFNetworking'
    pod 'Mantle'
    pod 'MBProgressHUD'
    pod 'SAMKeychain'
    pod 'dsBridge'
    pod 'Aspects'    
    
  end

  target 'KZWFoundationTests' do

  end

  target 'KZWFoundationUITests' do

  end
  
  
  post_install do |installer_representation|
      installer_representation.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
          end
      end
end

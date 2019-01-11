#
#  Be sure to run `pod spec lint KZWFoundation.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    
    s.name         = "KZWFoundation"
    s.version      = "2.0.1"
    s.summary      = "iOS 基本库"
    
    s.description  = <<-DESC
    iOS基本库
    DESC
    
    s.homepage     = "https://github.com/ouyrp/KZWFoundation"
    
    s.license      = "MIT"
    
    s.author             = { "ouyang" => "1697006288@qq.com" }

    s.platform     = :ios, "8.0"
    
    
    s.source       = { :git => "https://github.com/ouyrp/KZWFoundation.git", :tag => "#{s.version}" }
    
    s.source_files  = "KZWFoundation/Classes/KZWFoundationHear.h"
    
    s.subspec 'Content' do |ss|
        ss.source_files = 'KZWFoundation/Classes/**/*'
        ss.resource_bundle = { 'KZWFundation' => 'KZWFoundation/Assets/*' }
        ss.exclude_files = "KZWFoundation/Classes/KZWFoundationHear.h"
        ss.frameworks = "MapKit" , "WebKit" , "AudioToolbox"
    end
    s.dependency "Masonry"
    s.dependency "MJRefresh"
    s.dependency "AFNetworking"
    s.dependency "Mantle"
    s.dependency "MBProgressHUD"
    s.dependency "SAMKeychain"
    s.dependency "dsBridge"
    
end

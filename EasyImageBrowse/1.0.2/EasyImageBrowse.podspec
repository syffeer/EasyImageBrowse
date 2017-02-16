#
#  Be sure to run `pod spec lint EasyImageBrowse.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

s.name         = "EasyImageBrowse"
s.version      = "1.0.2"
s.summary      = "EasyImageBrowse."
s.description  = <<-DESC
私有Pods测试
* Markdown 格式
DESC

s.author        = { "MF_sy" => "sytoby@163.com" }
s.platform     = :ios, "8.0"

s.homepage     = "http://www.baidu.com"
s.license      = "MIT"
  s.ios.deployment_target = '8.0'
s.source       = { :git => "https://github.com/syffeer/EasyImageBrowse.git", :tag => "1.0.2" }
s.source_files  = "EasyImageBrowse/**/*.{h,m}"
s.requires_arc = true
s.frameworks = 'Foundation', 'SystemConfiguration'
end

#
# Be sure to run `pod lib lint LINStorage.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "LINStorage"
  s.version          = "0.1.0"
  s.summary          = "Simple NSKeyedArchiver wrapper"
  s.homepage         = "https://github.com/ryohey/LINStorage"
  s.license          = 'MIT'
  s.author           = { "ryohey" => "r.kameyama@covelline.com" }
  s.source           = { :git => "https://github.com/ryohey/LINStorage.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end

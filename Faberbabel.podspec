#
# Be sure to run `pod lib lint Faberbabel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Faberbabel'
  s.version          = '0.1.0'
  s.summary          = 'Faberbabel iOS SDK'
  s.homepage         = 'https://github.com/faberNovel'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jean Haberer' => 'jean.haberer@fabernovel.com' }
  s.source           = { :git => 'https://github.com/faberNovel/faberbabel-ios.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.swift_version = '5.0'
  s.source_files = 'Faberbabel/Classes/**/*'
end

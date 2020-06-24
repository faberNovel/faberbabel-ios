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

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    Use Faberbabel in your iOS app easily with this framework.
                      DESC

  s.homepage         = 'https://github.com/faberNovel'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jean Haberer' => 'jean.haberer@fabernovel.com' }
  s.source           = { :git => 'https://github.com/faberNovel/faberbabel-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.swift_version = '5.0'

  s.source_files = 'Faberbabel/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Faberbabel' => ['Faberbabel/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

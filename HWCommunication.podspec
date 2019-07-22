#
# Be sure to run `pod lib lint HWCommunication.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HWCommunication'
  s.version          = '0.0.10'
  s.summary          = 'HWCommunication.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/zrbaihld/HWCommunication_ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zrbaihld' => '360599892@qq.com' }
  s.source           = { :git => 'https://github.com/zrbaihld/HWCommunication_ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HWCommunication/Classes/**/*'

  s.resource_bundles = {
  #   'HWCommunication' => ['HWCommunication/Assets/*.png']
      'HWCommunication' => ['HWCommunication/*.cer']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'AFNetworking', '~> 3.2.1'
  s.dependency 'Socket.IO-Client-Swift', '~> 15.1.0'
  s.dependency 'FMDB', '~> 2.7.5'
  s.dependency 'Masonry', '~> 1.0.1'
  s.dependency 'YYModel', '~> 1.0.4'
  s.dependency 'AgoraRtcEngine_iOS', '~> 2.4.0.1'
  s.static_framework = true
  s.swift_version = '4.2'
  s.prefix_header_file = 'HWCommunication/Classes/HW_PrefixHeader.pch'

end

#
# Be sure to run `pod lib lint RCSceneNetworkKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RCSceneNetworkKit'
  s.version          = '0.1.0'
  s.summary          = 'RCSceneNetworkKit of RongCloud Scene.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
			RongCloud RCSceneNetworkKit SDK for iOS.
                       DESC

  s.homepage         = 'https://github.com/rongcloud-community'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license      = { :type => "Copyright", :text => "Copyright 2022 RongCloud" }
  s.author           = { '彭蕾' => 'penglei1@rongcloud.cn' }
  s.source           = { :git => 'git@github.com:rongcloud-community/RCSceneNetworkKit.git', :tag => s.version.to_s }

  s.social_media_url = 'https://www.rongcloud.cn/devcenter'

  s.ios.deployment_target = '11.0'

  s.source_files = 'RCSceneNetworkKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'RCSceneNetworkKit' => ['RCSceneNetworkKit/Assets/**/*']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

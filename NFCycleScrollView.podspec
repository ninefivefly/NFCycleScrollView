#
# Be sure to run `pod lib lint NFCycleScrollView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NFCycleScrollView'
  s.version          = '0.1.0'
  s.summary          = '循环滚动图片、支持本地和网络图片.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
1. 循环滚动图片
2. 支持本地和网络图片
3. 当手指滑动时停止计时
                       DESC

  s.homepage         = 'https://github.com/ninefivefly/NFCycleScrollView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jiang PengCheng' => 'ninefivefly@foxmail.com' }
  s.source           = { :git => 'https://github.com/ninefivefly/NFCycleScrollView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'NFCycleScrollView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'NFCycleScrollView' => ['NFCycleScrollView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

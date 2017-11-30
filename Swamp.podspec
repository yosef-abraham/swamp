#
# Be sure to run `pod lib lint Swamp.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Swamp'
  s.version          = '0.2.0'
  s.summary          = 'WAMP protocol implementation in swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
the WAMP WebSocket subprotocol implemented purely in Swift using Starscream, SwiftyJSON
                       DESC

  s.homepage         = 'https://github.com/iscriptology/Swamp'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Yossi Abraham' => 'yo.ab@outlook.com' }
  s.source           = { :git => 'https://github.com/iscriptology/Swamp.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.11'

  s.source_files = 'Swamp/**/*'

  # s.resource_bundles = {
  #   'Swamp' => ['Swamp/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Starscream'
  s.dependency 'CryptoSwift'
end

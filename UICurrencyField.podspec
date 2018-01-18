#
# Be sure to run `pod lib lint UICurrencyField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UICurrencyField'
  s.version          = '0.0.1'
  s.summary          = 'The missing text field for currencies'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
UITextfield for amount/price entry. Customizable style for integer, decimal part of the amount. Currency symbol indicator and formatting currency with given locale.
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/thomas-sivilay/UICurrencyField'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'thomassivilay' => 'thomas.sivilay@gmail.com' }
  s.source           = { :git => 'https://github.com/thomas-sivilay/UICurrencyField.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/thomassivilay'

  s.ios.deployment_target = '9.0'

  s.source_files = 'UICurrencyField/Classes/**/*'
  
  # s.resource_bundles = {
  #   'UICurrencyField' => ['UICurrencyField/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end

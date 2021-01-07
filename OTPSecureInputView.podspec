#
# Be sure to run `pod lib lint OTPInputView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OTPSecureInputView'
  s.version          = '1.0.0'
  s.summary          = 'OTP SecureInputView is a simple, Fully customisable OTP code verification view in Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    'OTP-SecureInputView is a fork of OTPInputView by abhishek-001, an awesome pod aimed to make your life easier when dealing with OTP Verification i.e Very common feature in Apps nowadays.'
                       DESC

                       s.homepage         = 'https://github.com/ernesto-pereira/OTPInputView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'abhishek-001' => 'work.abhirathi@gmail.com' }
  s.source           = { :git => 'https://github.com/ernesto-pereira/OTPInputView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.resources = ['Assets/**/*.png']
  s.source_files = 'OTPSecureInputView/Classes/*.swift'
  s.resource_bundles = {
    'OTPSecureInputView' => [
        'Assets/**/*.{png}'
    ]
  }
  s.frameworks = 'UIKit'
  s.swift_version = '4.0'
  
end

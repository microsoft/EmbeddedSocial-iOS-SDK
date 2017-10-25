Pod::Spec.new do |s|
  s.platform = :ios
  s.ios.deployment_target = '9.0'
  s.name = 'EmbeddedSocial'
  s.version = '0.7.4'
  s.summary = 'SDK for interacting with the Microsoft Embedded Social service from inside your iOS app.'
  s.requires_arc = true

  s.description = 'This is an SDK that works with the Microsoft Embedded Social service to provide social networking functionality inside your iOS application.'

  s.homepage = 'https://github.com/Microsoft/EmbeddedSocial-iOS-SDK'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Microsoft' => 'opencode@microsoft.com' }
  s.source = {
      :git => 'https://github.com/Microsoft/EmbeddedSocial-iOS-SDK.git',
      :tag => s.version.to_s,
      :submodules => true
  }
  s.source_files = 'EmbeddedSocial/Sources/**/*.swift', 'EmbeddedSocial/Vendor/OAuthSwift/**/*.swift', 'EmbeddedSocial/Vendor/MSR-EmbeddedSocial-Swift-API-Library/EmbeddedSocialClient/Classes/**/*.swift'
  s.resource_bundles = {
    'EmbeddedSocialResources' => ['EmbeddedSocial/Resources/*.{xcassets,plist}'],
    'EmbeddedSocialStoryboards' => ['EmbeddedSocial/Sources/**/*.storyboard'],
    'EmbeddedSocialThemes' => ['EmbeddedSocial/Sources/**/*.plist']
  }
  s.xcconfig = { 'SWIFT_INCLUDE_PATHS' => '$(PODS_TARGET_SRCROOT)/EmbeddedSocial/Vendor/LiveSDK' }
  s.preserve_paths = 'EmbeddedSocial/Vendor/LiveSDK/module.modulemap'
  s.static_framework = true
  s.ios.frameworks = [
    'UIKit',
    'AVFoundation',
    'CoreMedia'
  ]

  s.subspec 'no-arc' do |ss|
    ss.source_files = 'EmbeddedSocial/Vendor/LiveSDK/**/*.{h,m}'
    ss.requires_arc = false
    ss.compiler_flags = '-fno-objc-arc'
  end

  # ――― Dependencies ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.dependency 'Alamofire', '~> 4.5.0'
  s.dependency 'SwiftLint', '~> 0.20.1'
  s.dependency 'SnapKit', '~> 3.2.0'
  s.dependency 'SlideMenuControllerSwift', '~> 3.0'
  s.dependency 'TwitterKit', '~> 2.8.0'
  s.dependency 'TwitterCore', '~> 2.8.0'
  s.dependency 'GoogleSignIn', '~> 4.0.2'
  s.dependency 'SDWebImage', '~> 4.0.0'
  s.dependency 'SwiftGen', '~> 4.2.1'
  s.dependency 'Sourcery', '~> 0.7.2'
  s.dependency 'UITextView+Placeholder', '~> 1.2.0'
  s.dependency 'SKPhotoBrowser', '~> 4.0.1'
  s.dependency 'MBProgressHUD', '~> 1.0'
  s.dependency 'TTTAttributedLabel', '~> 2.0'
  s.dependency 'HockeySDK/AllFeaturesLib', '~> 5.0.0'
  s.dependency 'FBSDKCoreKit', '~> 4.24.0'
  s.dependency 'FBSDKLoginKit', '~> 4.24.0'
  s.dependency 'FBSDKShareKit', '~> 4.24.0'

end

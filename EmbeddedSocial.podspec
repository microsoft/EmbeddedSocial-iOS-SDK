Pod::Spec.new do |s|
  s.platform = :ios
  s.ios.deployment_target = '9.0'
  s.name = 'EmbeddedSocial'
  s.version = '0.7.4'
  s.summary = 'SDK for interacting with the Microsoft Embedded Social service from inside your iOS app.'
  s.requires_arc = true

  s.description = <<-DESC
                  This is an SDK that works with the Microsoft Embedded Social service to provide social networking functionality inside your iOS application.
                  DESC

  s.homepage = 'https://github.com/Microsoft/EmbeddedSocial-iOS-SDK'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Microsoft' => 'opencode@microsoft.com' }
  s.source = {
      :git => 'https://github.com/Microsoft/EmbeddedSocial-iOS-SDK.git',
      :tag => s.version.to_s,
      :submodules => true
  }
  s.source_files = 'EmbeddedSocial/Sources/**/*.swift'
  s.resource_bundles = {
    'EmbeddedSocialResources' => ['EmbeddedSocial/Resources/*.{xcassets,plist}'],
    'EmbeddedSocialStoryboards' => ['EmbeddedSocial/Sources/**/*.storyboard'],
    'EmbeddedSocialThemes' => ['EmbeddedSocial/Sources/**/*.plist']
  }

  # ――― Dependencies ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.dependency 'Alamofire', '~> 4.5.0'
  s.dependency 'SwiftLint', '~> 0.20.1'
  s.dependency 'SnapKit', '~> 3.2.0'
  s.dependency 'SlideMenuControllerSwift', '~> 3.0'
  s.dependency 'TwitterKit', '~> 2.8.0'
  s.dependency 'GoogleSignIn', '~> 4.0.2'
  s.dependency 'SDWebImage', '~> 4.0.0'
  s.dependency 'SwiftGen', '~> 4.2.1'
  s.dependency 'Sourcery', '~> 0.7.2'
  s.dependency 'UITextView+Placeholder', '~> 1.2.0'
  #s.dependency 'OAuthSwift-Local'
  #s.dependency 'EmbeddedSocial/Vendor/OAuthSwift'
  #s.dependency 'OAuthSwift', :local => 'EmbeddedSocial/Vendor/OAuthSwift'
  # s.dependency 'LiveSDK', :local => 'EmbeddedSocial/Vendor/LiveSDK'
  s.dependency 'SKPhotoBrowser', '~> 4.0.1'
  s.dependency 'MBProgressHUD', '~> 1.0'
  s.dependency 'TTTAttributedLabel', '~> 2.0'
  s.dependency 'HockeySDK/AllFeaturesLib', '~> 5.0.0'
  s.dependency 'FBSDKCoreKit', '~> 4.24.0'
  s.dependency 'FBSDKLoginKit', '~> 4.24.0'
  s.dependency 'FBSDKShareKit', '~> 4.24.0'

  s.subspec 'OAuthSwift-Local' do |ss|
    ss.source_files = 'EmbeddedSocial/Vendor/OAuthSwift/Sources/*.swift'
  end

end

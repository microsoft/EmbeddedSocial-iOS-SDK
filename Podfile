platform :ios, ‘9.0’

use_frameworks!
inhibit_all_warnings!

def facebook
    pod 'FBSDKCoreKit', '4.24.0'
    pod 'FBSDKLoginKit', '4.24.0'
    pod 'FBSDKShareKit', '4.24.0'
end

abstract_target 'Group' do

    pod 'Alamofire', '4.5.0'
    pod 'SwiftLint', '0.20.1'
    pod 'SnapKit', '3.2.0'
    pod 'SlideMenuControllerSwift', '3.0'
    pod 'TwitterKit', '2.8.0'
    pod 'GoogleSignIn', '4.0.2'
    pod 'SDWebImage', '4.0.0'
    pod 'SwiftGen', '4.2.1'
    pod 'Sourcery', '0.7.2'
    pod 'UITextView+Placeholder', '1.2.0'
    pod 'OAuthSwift', :path => 'EmbeddedSocial/Vendor/OAuthSwift'
    pod 'LiveSDK', :path => 'EmbeddedSocial/Vendor/LiveSDK'
    pod 'SKPhotoBrowser', '4.0.1'
    pod 'MBProgressHUD', '1.0'
    pod 'TTTAttributedLabel', '2.0'
    pod 'HockeySDK', '~> 5.0.0', :subspecs => ['AllFeaturesLib']
    pod 'BMACollectionBatchUpdates', '~> 1.1'
    facebook

    target 'EmbeddedSocial' do
      target 'EmbeddedSocialTests' do
        inherit! :search_paths
        pod 'Quick'
        pod 'Nimble'

        end
    end

    target 'EmbeddedSocial-Example' do

    end

    target 'EmbeddedSocialUITests' do
        pod 'Embassy', ‘4.0’
        pod 'EnvoyAmbassador', ‘4.0’
    end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'Embassy' || target.name == 'EnvoyAmbassador'
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = ‘4.0’
      end
    end
  end
end

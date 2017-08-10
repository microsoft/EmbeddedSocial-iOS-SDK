platform :ios, ‘8.0’

use_frameworks!
inhibit_all_warnings!

def facebook
    pod 'FBSDKCoreKit', '~> 4.24.0'
    pod 'FBSDKLoginKit', '~> 4.24.0'
    pod 'FBSDKShareKit', '~> 4.24.0'
end

abstract_target 'Group' do

    pod 'Alamofire', '~> 4.5.0'
    pod 'SwiftLint', '~> 0.20.1'
    pod 'SVProgressHUD', '~> 2.1.2'
    pod 'SnapKit', '~> 3.2.0'
    pod 'SlideMenuControllerSwift', '~> 3.0'
    pod 'TwitterKit', '~> 2.8.1'
    pod 'GoogleSignIn', '~> 4.0.2'
    pod 'SDWebImage', '~> 4.0.0'
    pod 'SwiftGen', '~> 4.2.1'
    pod 'UITextView+Placeholder', '~> 1.2.0'
    pod 'OAuthSwift', :path => 'EmbeddedSocial/Vendor/OAuthSwift'
    pod 'LiveSDK', :path => 'EmbeddedSocial/Vendor/LiveSDK'
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
        pod 'Embassy', '~> 3.1’
        pod 'EnvoyAmbassador', '~> 3.0’
    end

end

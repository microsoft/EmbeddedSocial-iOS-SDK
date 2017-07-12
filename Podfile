platform :ios, ‘8.0’

use_frameworks!
inhibit_all_warnings!

def facebook
    pod 'FBSDKCoreKit'
    pod 'FBSDKLoginKit'
    pod 'FBSDKShareKit'
end

def microsoft
    pod 'MSGraphSDK'
    pod 'MSGraphSDK-NXOAuth2Adapter', :path => './MSGP/Vendor/MSGraphSDK-NXOAuth2Adapter'
end

abstract_target 'Group' do
    
    pod 'Alamofire'
    pod 'SwiftLint'
    pod 'SVProgressHUD'
    pod 'SnapKit'
    pod 'SlideMenuControllerSwift', '~> 3.0'
    pod 'TwitterKit'
    pod 'Google/SignIn'
    facebook
    microsoft
    
    target 'MSGP' do
               
        target 'MSGPTests' do
            inherit! :search_paths
            # Pods for testing
            
        end
        
    end
    
    target 'MSGP-Example' do
        
    end
    
end

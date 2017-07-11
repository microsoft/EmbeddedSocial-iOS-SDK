platform :ios, ‘8.3’

use_frameworks!

def facebook
    pod 'FBSDKCoreKit'
    pod 'FBSDKLoginKit'
    pod 'FBSDKShareKit'
end

abstract_target 'Group' do
    
    pod 'Alamofire'
    pod 'SwiftLint'
    pod 'SVProgressHUD'
    pod 'SnapKit'
    pod 'SlideMenuControllerSwift', '~> 3.0'
    pod 'TwitterKit'
    facebook
    
    target 'MSGP' do
               
        target 'MSGPTests' do
            inherit! :search_paths
            # Pods for testing
            
        end
        
    end
    
    target 'MSGP-Example' do
        
    end
    
end

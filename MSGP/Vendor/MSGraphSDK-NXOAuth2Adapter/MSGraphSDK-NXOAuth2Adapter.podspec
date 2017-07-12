
Pod::Spec.new do |s|

  s.name         = "MSGraphSDK-NXOAuth2Adapter"
  s.version      = "0.9.2"
  s.summary      = "Limited-scope OAuth2 implementation using the NXOAuth2 library for use with the Microsoft Graph SDK"
  s.description  = <<-DESC
                    Limited-scope implementation of MSAuthenticationProvider that can perform UI login for apps registered on apps.dev.microsoft.com
                   DESC
  s.homepage     = "http://azure.microsoft.com/en-us/documentation/articles/active-directory-v2-protocols-oauth-code/"
  s.license      = { :type => "MIT", :file => "LICENSE.txt" }
  s.author        = 'Microsoft Graph'

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/MicrosoftGraph/msgraph-sdk-ios-nxoauth2-adapter",
                     :tag => "#{s.version}" }

  s.source_files = "MSGraphSDKNXOAuth2/MSGraphSDKNXOAuth2.h"
  s.public_header_files = "MSGraphSDKNXOAuth2/MSGraphSDKNXOAuth2.h"

  s.subspec 'Common' do |common|
    common.source_files = "MSGraphSDKNXOAuth2/Common/*.{h,m}"
    common.public_header_files = "MSGraphSDKNXOAuth2/Common/*.h"
  end

  s.subspec 'Auth' do |auth|
    auth.dependency 'MSGraphSDK-NXOAuth2Adapter/Common'
    auth.dependency 'NXOAuth2Client', '~> 1.2.8'
    auth.dependency 'MSGraphSDK/Common'
    auth.dependency 'MSGraphSDK/Implementations'

    auth.source_files = "MSGraphSDKNXOAuth2/Auth/*.{h,m}"
    auth.public_header_files = "MSGraphSDKNXOAuth2/Auth/*.h"
  end
  
  s.subspec 'Extensions' do |ext|
    ext.dependency 'MSGraphSDK-NXOAuth2Adapter/Common'
    
    ext.source_files = "MSGraphSDKNXOAuth2/Extensions/*.{h,m}"
    ext.public_header_files = "MSGraphSDKNXOAuth2/Extensions/*.h"
  end
end

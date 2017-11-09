# Microsoft Research Embedded Social Software Development Kit

## iOS SDK

EmbeddesSocial is an SDK that works with the Microsoft Embedded Social service to provide social networking functionality inside your iOS application.

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Advanced Usage](#advanced-usage)
- [License](#license)

## Features

- [x] Feature 1
- [x] Feature 2

## Requirements

- iOS 9.0+
- Xcode 8.3+
- Swift 3.2

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods [--pre]
```

> CocoaPods 1.4.0+ is required to build EmbeddedSocial SDK.

To integrate EmbeddedSocial SDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
target '<Your Target Name>' do
  use_frameworks!

  pod 'EmbeddedSocial', :git => 'https://github.com/Microsoft/EmbeddedSocial-iOS-SDK.git', :branch => 'develop', :submodules => true
  
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
    	target.build_configurations.each do |config|
        	config.build_settings['SWIFT_VERSION'] = ‘3.2’
        end
    end
end
```

Then, run the following command:

```bash
$ pod install
```

## Usage

### Info.plist

Insert the following lines in your `Info.plist` file in your project:

```
<key>LSApplicationQueriesSchemes</key>
<array>
	<string>fbapi</string>
	<string>fb-messenger-api</string>
	<string>fbauth2</string>
	<string>fbshareextension</string>
	<string>twitter</string>
	<string>twitterauth</string>
</array>
```

For Sign In functionality works, you should register your Application Bundle Identifier in:
- [Microsoft Developer Console](https://msdn.microsoft.com/en-us/library/hh826541.aspx)
- [Google Developer Console](https://console.cloud.google.com/)
- [Facebook Developer Console](https://developers.facebook.com)
- [Twitter Developer Console](https://developer.twitter.com/en/docs/basics/authentication/guides/access-tokens) 

After your Application registered, you will receive API keys. You should insert following lines in your `Info.plist` file:

```
<key>CFBundleURLTypes</key>
<array>
	<dict>
		<key>CFBundleURLSchemes</key>
		<array>
			<string> *YOUR FB APP KEY* </string>
		</array>
	</dict>
	<dict>
		<key>CFBundleURLSchemes</key>
		<array>
			<string> *YOUR TWITTER APP KEY* </string>
		</array>
	</dict>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<string> *YOUR GOOGLE APP KEY* </string>
		</array>
	</dict>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
		</array>
	</dict>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLName</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string> *YOUR MICROSOFT APP KEY* </string>
      <string>auth</string>
      </array>
  </dict>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>embeddedsocial</string>
    </array>
  </dict>
</array>
```

### AppDelegate.swift

Please, insert the following lines in your `AppDelegate.swift` file.

For SDK initialization:

```swift
func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
             
    let args = LaunchArguments(app: application,
                               window: window!,
                               launchOptions: launchOptions ?? [:],
                               menuHandler: SideMenuItemsProvider,
                               menuConfiguration: .tab)
    SocialPlus.shared.start(launchArguments: args)

    return true
}
```

For URL shemes handling:

```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
    return SocialPlus.shared.application(app, open: url, options: options)
}
```

For Push Notifications handling:

```swift
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
    SocialPlus.shared.updateDeviceToken(devictToken: deviceTokenString)
}

func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
    SocialPlus.shared.didReceiveRemoteNotification(data: data)
}
```

## Advanced Usage

### Menu

#### Menu Types

You can implement on of three menu types provided by `SideMenuType`:

```swift
public enum SideMenuType {
    case tab, dual, single
}
```
> You can specify this in `AppDelegate.swift` with `menuConfiguration` parameter in `LaunchArguments`. For example:
> ```swift
>let args = LaunchArguments(..., menuConfiguration: .tab | .dual | .single)
>```

#### Menu Handler

You can implement your own menu items. You should make implementation for `SideMenuItemsProvider`:

```swift
public protocol SideMenuItemsProvider: class {
    func numberOfItems() -> Int
    func image(forItem index: Int) -> UIImage
    func imageHighlighted(forItem index: Int) -> UIImage
    func title(forItem index: Int) -> String
    func destination(forItem index: Int) -> UIViewController
}
```
> You can handle this in `AppDelegate.swift` with `menuHandler` parameter in `LaunchArguments`. For example:
> ```swift
>let menu: SideMenuItemsProvider = MyMenuImplementation()
>let args = LaunchArguments(..., menuHandler: menu , ...)
>```

## License

By using this code, you agree to the [Developer Code of Conduct](DeveloperCodeOfConduct.md), and the [License Terms](LICENSE).

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

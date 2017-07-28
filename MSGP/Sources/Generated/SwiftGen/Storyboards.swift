// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation
import UIKit

// swiftlint:disable file_length
// swiftlint:disable line_length
// swiftlint:disable type_body_length

protocol StoryboardSceneType {
  static var storyboardName: String { get }
}

extension StoryboardSceneType {
  static func storyboard() -> UIStoryboard {
    return UIStoryboard(name: self.storyboardName, bundle: Bundle(for: BundleToken.self))
  }

  static func initialViewController() -> UIViewController {
    guard let vc = storyboard().instantiateInitialViewController() else {
      fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
    }
    return vc
  }
}

extension StoryboardSceneType where Self: RawRepresentable, Self.RawValue == String {
  func viewController() -> UIViewController {
    return Self.storyboard().instantiateViewController(withIdentifier: self.rawValue)
  }
  static func viewController(identifier: Self) -> UIViewController {
    return identifier.viewController()
  }
}

protocol StoryboardSegueType: RawRepresentable { }

extension UIViewController {
  func perform<S: StoryboardSegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
    performSegue(withIdentifier: segue.rawValue, sender: sender)
  }
}

enum StoryboardScene {
  enum CreateAccount: String, StoryboardSceneType {
    static let storyboardName = "CreateAccount"

    static func initialViewController() -> MSGP.CreateAccountViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? MSGP.CreateAccountViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case createAccountViewControllerScene = "CreateAccountViewController"
    static func instantiateCreateAccountViewController() -> MSGP.CreateAccountViewController {
      guard let vc = StoryboardScene.CreateAccount.createAccountViewControllerScene.viewController() as? MSGP.CreateAccountViewController
      else {
        fatalError("ViewController 'CreateAccountViewController' is not of the expected class MSGP.CreateAccountViewController.")
      }
      return vc
    }
  }
  enum CreatePost: String, StoryboardSceneType {
    static let storyboardName = "CreatePost"

    case createPostViewControllerScene = "CreatePostViewController"
    static func instantiateCreatePostViewController() -> MSGP.CreatePostViewController {
      guard let vc = StoryboardScene.CreatePost.createPostViewControllerScene.viewController() as? MSGP.CreatePostViewController
      else {
        fatalError("ViewController 'CreatePostViewController' is not of the expected class MSGP.CreatePostViewController.")
      }
      return vc
    }
  }
  enum Login: String, StoryboardSceneType {
    static let storyboardName = "Login"

    static func initialViewController() -> MSGP.LoginViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? MSGP.LoginViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case loginViewControllerScene = "LoginViewController"
    static func instantiateLoginViewController() -> MSGP.LoginViewController {
      guard let vc = StoryboardScene.Login.loginViewControllerScene.viewController() as? MSGP.LoginViewController
      else {
        fatalError("ViewController 'LoginViewController' is not of the expected class MSGP.LoginViewController.")
      }
      return vc
    }
  }
  enum MenuStack: String, StoryboardSceneType {
    static let storyboardName = "MenuStack"

    static func initialViewController() -> UINavigationController {
      guard let vc = storyboard().instantiateInitialViewController() as? UINavigationController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case navigationStackContainerScene = "NavigationStackContainer"
    static func instantiateNavigationStackContainer() -> MSGP.NavigationStackContainer {
      guard let vc = StoryboardScene.MenuStack.navigationStackContainerScene.viewController() as? MSGP.NavigationStackContainer
      else {
        fatalError("ViewController 'NavigationStackContainer' is not of the expected class MSGP.NavigationStackContainer.")
      }
      return vc
    }

    case sideMenuViewControllerScene = "SideMenuViewController"
    static func instantiateSideMenuViewController() -> MSGP.SideMenuViewController {
      guard let vc = StoryboardScene.MenuStack.sideMenuViewControllerScene.viewController() as? MSGP.SideMenuViewController
      else {
        fatalError("ViewController 'SideMenuViewController' is not of the expected class MSGP.SideMenuViewController.")
      }
      return vc
    }
  }
  enum UserProfile: String, StoryboardSceneType {
    static let storyboardName = "UserProfile"

    case userProfileViewControllerScene = "UserProfileViewController"
    static func instantiateUserProfileViewController() -> MSGP.UserProfileViewController {
      guard let vc = StoryboardScene.UserProfile.userProfileViewControllerScene.viewController() as? MSGP.UserProfileViewController
      else {
        fatalError("ViewController 'UserProfileViewController' is not of the expected class MSGP.UserProfileViewController.")
      }
      return vc
    }
  }
}

enum StoryboardSegue {
}

private final class BundleToken {}

// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation
import UIKit
import MSGP
import SocialPlusv0

// swiftlint:disable file_length
// swiftlint:disable line_length
// swiftlint:disable type_body_length

protocol StoryboardSceneType {
  static var storyboardName: String { get }
}

extension StoryboardSceneType {
  static func storyboard() -> UIStoryboard {
    return UIStoryboard(name: self.storyboardName, bundle: NSBundle(forClass: BundleToken.self))
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
    return Self.storyboard().instantiateViewControllerWithIdentifier(self.rawValue)
  }
  static func viewController(identifier: Self) -> UIViewController {
    return identifier.viewController()
  }
}

protocol StoryboardSegueType: RawRepresentable { }

extension UIViewController {
  func performSegue<S: StoryboardSegueType where S.RawValue == String>(segue: S, sender: AnyObject? = nil) {
    performSegueWithIdentifier(segue.rawValue, sender: sender)
  }
}

enum StoryboardScene {
  enum CreateAccount: String, StoryboardSceneType {
    static let storyboardName = "CreateAccount"

    static func initialViewController() -> SocialPlusv0.CreateAccountViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? SocialPlusv0.CreateAccountViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case CreateAccountViewControllerScene = "CreateAccountViewController"
    static func instantiateCreateAccountViewController() -> SocialPlusv0.CreateAccountViewController {
      guard let vc = StoryboardScene.CreateAccount.CreateAccountViewControllerScene.viewController() as? SocialPlusv0.CreateAccountViewController
      else {
        fatalError("ViewController 'CreateAccountViewController' is not of the expected class SocialPlusv0.CreateAccountViewController.")
      }
      return vc
    }
  }
  enum Login: String, StoryboardSceneType {
    static let storyboardName = "Login"

    static func initialViewController() -> SocialPlusv0.LoginViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? SocialPlusv0.LoginViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case LoginViewControllerScene = "LoginViewController"
    static func instantiateLoginViewController() -> SocialPlusv0.LoginViewController {
      guard let vc = StoryboardScene.Login.LoginViewControllerScene.viewController() as? SocialPlusv0.LoginViewController
      else {
        fatalError("ViewController 'LoginViewController' is not of the expected class SocialPlusv0.LoginViewController.")
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

    case NavigationStackContainerScene = "NavigationStackContainer"
    static func instantiateNavigationStackContainer() -> MSGP.NavigationStackContainer {
      guard let vc = StoryboardScene.MenuStack.NavigationStackContainerScene.viewController() as? MSGP.NavigationStackContainer
      else {
        fatalError("ViewController 'NavigationStackContainer' is not of the expected class MSGP.NavigationStackContainer.")
      }
      return vc
    }

    case NavigationStackMenuScene = "NavigationStackMenu"
    static func instantiateNavigationStackMenu() -> MSGP.MenuViewController {
      guard let vc = StoryboardScene.MenuStack.NavigationStackMenuScene.viewController() as? MSGP.MenuViewController
      else {
        fatalError("ViewController 'NavigationStackMenu' is not of the expected class MSGP.MenuViewController.")
      }
      return vc
    }

    case TabMenuContainerViewControllerScene = "TabMenuContainerViewController"
    static func instantiateTabMenuContainerViewController() -> MSGP.TabMenuContainerViewController {
      guard let vc = StoryboardScene.MenuStack.TabMenuContainerViewControllerScene.viewController() as? MSGP.TabMenuContainerViewController
      else {
        fatalError("ViewController 'TabMenuContainerViewController' is not of the expected class MSGP.TabMenuContainerViewController.")
      }
      return vc
    }
  }
}

enum StoryboardSegue {
}

private final class BundleToken {}

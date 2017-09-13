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
  enum Activity: String, StoryboardSceneType {
    static let storyboardName = "Activity"

    case activityViewControllerScene = "ActivityViewController"
    static func instantiateActivityViewController() -> EmbeddedSocial.ActivityViewController {
      guard let vc = StoryboardScene.Activity.activityViewControllerScene.viewController() as? EmbeddedSocial.ActivityViewController
      else {
        fatalError("ViewController 'ActivityViewController' is not of the expected class EmbeddedSocial.ActivityViewController.")
      }
      return vc
    }
  }
  enum BlockedUsers: String, StoryboardSceneType {
    static let storyboardName = "BlockedUsers"

    case blockedUsersViewControllerScene = "BlockedUsersViewController"
    static func instantiateBlockedUsersViewController() -> EmbeddedSocial.BlockedUsersViewController {
      guard let vc = StoryboardScene.BlockedUsers.blockedUsersViewControllerScene.viewController() as? EmbeddedSocial.BlockedUsersViewController
      else {
        fatalError("ViewController 'BlockedUsersViewController' is not of the expected class EmbeddedSocial.BlockedUsersViewController.")
      }
      return vc
    }
  }
  enum CommentReplies: String, StoryboardSceneType {
    static let storyboardName = "CommentReplies"

    case commentRepliesViewControllerScene = "CommentRepliesViewController"
    static func instantiateCommentRepliesViewController() -> EmbeddedSocial.CommentRepliesViewController {
      guard let vc = StoryboardScene.CommentReplies.commentRepliesViewControllerScene.viewController() as? EmbeddedSocial.CommentRepliesViewController
      else {
        fatalError("ViewController 'CommentRepliesViewController' is not of the expected class EmbeddedSocial.CommentRepliesViewController.")
      }
      return vc
    }
  }
  enum CreateAccount: String, StoryboardSceneType {
    static let storyboardName = "CreateAccount"

    static func initialViewController() -> EmbeddedSocial.CreateAccountViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? EmbeddedSocial.CreateAccountViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case createAccountViewControllerScene = "CreateAccountViewController"
    static func instantiateCreateAccountViewController() -> EmbeddedSocial.CreateAccountViewController {
      guard let vc = StoryboardScene.CreateAccount.createAccountViewControllerScene.viewController() as? EmbeddedSocial.CreateAccountViewController
      else {
        fatalError("ViewController 'CreateAccountViewController' is not of the expected class EmbeddedSocial.CreateAccountViewController.")
      }
      return vc
    }
  }
  enum CreatePost: String, StoryboardSceneType {
    static let storyboardName = "CreatePost"

    case createPostViewControllerScene = "CreatePostViewController"
    static func instantiateCreatePostViewController() -> EmbeddedSocial.CreatePostViewController {
      guard let vc = StoryboardScene.CreatePost.createPostViewControllerScene.viewController() as? EmbeddedSocial.CreatePostViewController
      else {
        fatalError("ViewController 'CreatePostViewController' is not of the expected class EmbeddedSocial.CreatePostViewController.")
      }
      return vc
    }
  }
  enum EditProfile: String, StoryboardSceneType {
    static let storyboardName = "EditProfile"

    static func initialViewController() -> EmbeddedSocial.EditProfileViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? EmbeddedSocial.EditProfileViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case editProfileViewControllerScene = "EditProfileViewController"
    static func instantiateEditProfileViewController() -> EmbeddedSocial.EditProfileViewController {
      guard let vc = StoryboardScene.EditProfile.editProfileViewControllerScene.viewController() as? EmbeddedSocial.EditProfileViewController
      else {
        fatalError("ViewController 'EditProfileViewController' is not of the expected class EmbeddedSocial.EditProfileViewController.")
      }
      return vc
    }
  }
  enum FeedModule: String, StoryboardSceneType {
    static let storyboardName = "FeedModule"

    case feedModuleViewControllerScene = "FeedModuleViewController"
    static func instantiateFeedModuleViewController() -> EmbeddedSocial.FeedModuleViewController {
      guard let vc = StoryboardScene.FeedModule.feedModuleViewControllerScene.viewController() as? EmbeddedSocial.FeedModuleViewController
      else {
        fatalError("ViewController 'FeedModuleViewController' is not of the expected class EmbeddedSocial.FeedModuleViewController.")
      }
      return vc
    }
  }
  enum Followers: String, StoryboardSceneType {
    static let storyboardName = "Followers"

    case followersViewControllerScene = "FollowersViewController"
    static func instantiateFollowersViewController() -> EmbeddedSocial.FollowersViewController {
      guard let vc = StoryboardScene.Followers.followersViewControllerScene.viewController() as? EmbeddedSocial.FollowersViewController
      else {
        fatalError("ViewController 'FollowersViewController' is not of the expected class EmbeddedSocial.FollowersViewController.")
      }
      return vc
    }
  }
  enum Following: String, StoryboardSceneType {
    static let storyboardName = "Following"

    case followingViewControllerScene = "FollowingViewController"
    static func instantiateFollowingViewController() -> EmbeddedSocial.FollowingViewController {
      guard let vc = StoryboardScene.Following.followingViewControllerScene.viewController() as? EmbeddedSocial.FollowingViewController
      else {
        fatalError("ViewController 'FollowingViewController' is not of the expected class EmbeddedSocial.FollowingViewController.")
      }
      return vc
    }
  }
  enum LikesList: String, StoryboardSceneType {
    static let storyboardName = "LikesList"

    case likesListViewControllerScene = "LikesListViewController"
    static func instantiateLikesListViewController() -> EmbeddedSocial.LikesListViewController {
      guard let vc = StoryboardScene.LikesList.likesListViewControllerScene.viewController() as? EmbeddedSocial.LikesListViewController
      else {
        fatalError("ViewController 'LikesListViewController' is not of the expected class EmbeddedSocial.LikesListViewController.")
      }
      return vc
    }
  }
  enum Login: String, StoryboardSceneType {
    static let storyboardName = "Login"

    static func initialViewController() -> EmbeddedSocial.LoginViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? EmbeddedSocial.LoginViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case loginViewControllerScene = "LoginViewController"
    static func instantiateLoginViewController() -> EmbeddedSocial.LoginViewController {
      guard let vc = StoryboardScene.Login.loginViewControllerScene.viewController() as? EmbeddedSocial.LoginViewController
      else {
        fatalError("ViewController 'LoginViewController' is not of the expected class EmbeddedSocial.LoginViewController.")
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
    static func instantiateNavigationStackContainer() -> EmbeddedSocial.NavigationStackContainer {
      guard let vc = StoryboardScene.MenuStack.navigationStackContainerScene.viewController() as? EmbeddedSocial.NavigationStackContainer
      else {
        fatalError("ViewController 'NavigationStackContainer' is not of the expected class EmbeddedSocial.NavigationStackContainer.")
      }
      return vc
    }

    case sideMenuViewControllerScene = "SideMenuViewController"
    static func instantiateSideMenuViewController() -> EmbeddedSocial.SideMenuViewController {
      guard let vc = StoryboardScene.MenuStack.sideMenuViewControllerScene.viewController() as? EmbeddedSocial.SideMenuViewController
      else {
        fatalError("ViewController 'SideMenuViewController' is not of the expected class EmbeddedSocial.SideMenuViewController.")
      }
      return vc
    }
  }
  enum PopularModuleView: String, StoryboardSceneType {
    static let storyboardName = "PopularModuleView"

    case popularModuleViewScene = "PopularModuleView"
    static func instantiatePopularModuleView() -> EmbeddedSocial.PopularModuleView {
      guard let vc = StoryboardScene.PopularModuleView.popularModuleViewScene.viewController() as? EmbeddedSocial.PopularModuleView
      else {
        fatalError("ViewController 'PopularModuleView' is not of the expected class EmbeddedSocial.PopularModuleView.")
      }
      return vc
    }
  }
  enum PostDetail: String, StoryboardSceneType {
    static let storyboardName = "PostDetail"

    case postDetailViewControllerScene = "PostDetailViewController"
    static func instantiatePostDetailViewController() -> EmbeddedSocial.PostDetailViewController {
      guard let vc = StoryboardScene.PostDetail.postDetailViewControllerScene.viewController() as? EmbeddedSocial.PostDetailViewController
      else {
        fatalError("ViewController 'PostDetailViewController' is not of the expected class EmbeddedSocial.PostDetailViewController.")
      }
      return vc
    }
  }
  enum Report: String, StoryboardSceneType {
    static let storyboardName = "Report"

    case reportSubmittedViewControllerScene = "ReportSubmittedViewController"
    static func instantiateReportSubmittedViewController() -> EmbeddedSocial.ReportSubmittedViewController {
      guard let vc = StoryboardScene.Report.reportSubmittedViewControllerScene.viewController() as? EmbeddedSocial.ReportSubmittedViewController
      else {
        fatalError("ViewController 'ReportSubmittedViewController' is not of the expected class EmbeddedSocial.ReportSubmittedViewController.")
      }
      return vc
    }

    case reportViewControllerScene = "ReportViewController"
    static func instantiateReportViewController() -> EmbeddedSocial.ReportViewController {
      guard let vc = StoryboardScene.Report.reportViewControllerScene.viewController() as? EmbeddedSocial.ReportViewController
      else {
        fatalError("ViewController 'ReportViewController' is not of the expected class EmbeddedSocial.ReportViewController.")
      }
      return vc
    }
  }
  enum Search: String, StoryboardSceneType {
    static let storyboardName = "Search"

    case searchViewControllerScene = "SearchViewController"
    static func instantiateSearchViewController() -> EmbeddedSocial.SearchViewController {
      guard let vc = StoryboardScene.Search.searchViewControllerScene.viewController() as? EmbeddedSocial.SearchViewController
      else {
        fatalError("ViewController 'SearchViewController' is not of the expected class EmbeddedSocial.SearchViewController.")
      }
      return vc
    }
  }
  enum SearchPeople: String, StoryboardSceneType {
    static let storyboardName = "SearchPeople"

    case searchPeopleViewControllerScene = "SearchPeopleViewController"
    static func instantiateSearchPeopleViewController() -> EmbeddedSocial.SearchPeopleViewController {
      guard let vc = StoryboardScene.SearchPeople.searchPeopleViewControllerScene.viewController() as? EmbeddedSocial.SearchPeopleViewController
      else {
        fatalError("ViewController 'SearchPeopleViewController' is not of the expected class EmbeddedSocial.SearchPeopleViewController.")
      }
      return vc
    }
  }
  enum SearchTopics: String, StoryboardSceneType {
    static let storyboardName = "SearchTopics"

    case searchTopicsViewControllerScene = "SearchTopicsViewController"
    static func instantiateSearchTopicsViewController() -> EmbeddedSocial.SearchTopicsViewController {
      guard let vc = StoryboardScene.SearchTopics.searchTopicsViewControllerScene.viewController() as? EmbeddedSocial.SearchTopicsViewController
      else {
        fatalError("ViewController 'SearchTopicsViewController' is not of the expected class EmbeddedSocial.SearchTopicsViewController.")
      }
      return vc
    }
  }
  enum Settings: String, StoryboardSceneType {
    static let storyboardName = "Settings"

    case settingsViewControllerScene = "SettingsViewController"
    static func instantiateSettingsViewController() -> EmbeddedSocial.SettingsViewController {
      guard let vc = StoryboardScene.Settings.settingsViewControllerScene.viewController() as? EmbeddedSocial.SettingsViewController
      else {
        fatalError("ViewController 'SettingsViewController' is not of the expected class EmbeddedSocial.SettingsViewController.")
      }
      return vc
    }
  }
  enum UserProfile: String, StoryboardSceneType {
    static let storyboardName = "UserProfile"

    case userProfileViewControllerScene = "UserProfileViewController"
    static func instantiateUserProfileViewController() -> EmbeddedSocial.UserProfileViewController {
      guard let vc = StoryboardScene.UserProfile.userProfileViewControllerScene.viewController() as? EmbeddedSocial.UserProfileViewController
      else {
        fatalError("ViewController 'UserProfileViewController' is not of the expected class EmbeddedSocial.UserProfileViewController.")
      }
      return vc
    }
  }
}

enum StoryboardSegue {
}

private final class BundleToken {}

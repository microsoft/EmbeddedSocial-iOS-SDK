// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable file_length

protocol StoryboardType {
  static var storyboardName: String { get }
}

extension StoryboardType {
  static var storyboard: UIStoryboard {
    return UIStoryboard(name: self.storyboardName, bundle: Bundle(for: BundleToken.self))
  }
}

struct SceneType<T: Any> {
  let storyboard: StoryboardType.Type
  let identifier: String

  func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

struct InitialSceneType<T: Any> {
  let storyboard: StoryboardType.Type

  func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

protocol SegueType: RawRepresentable { }

extension UIViewController {
  func perform<S: SegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
    performSegue(withIdentifier: segue.rawValue, sender: sender)
  }
}

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
enum StoryboardScene {
  enum Activity: StoryboardType {
    static let storyboardName = "Activity"

    static let activityViewController = SceneType<EmbeddedSocial.ActivityViewController>(storyboard: Activity.self, identifier: "ActivityViewController")
  }
  enum BlockedUsers: StoryboardType {
    static let storyboardName = "BlockedUsers"

    static let blockedUsersViewController = SceneType<EmbeddedSocial.BlockedUsersViewController>(storyboard: BlockedUsers.self, identifier: "BlockedUsersViewController")
  }
  enum CommentReplies: StoryboardType {
    static let storyboardName = "CommentReplies"

    static let commentRepliesViewController = SceneType<EmbeddedSocial.CommentRepliesViewController>(storyboard: CommentReplies.self, identifier: "CommentRepliesViewController")
  }
  enum CreateAccount: StoryboardType {
    static let storyboardName = "CreateAccount"

    static let initialScene = InitialSceneType<EmbeddedSocial.CreateAccountViewController>(storyboard: CreateAccount.self)

    static let createAccountViewController = SceneType<EmbeddedSocial.CreateAccountViewController>(storyboard: CreateAccount.self, identifier: "CreateAccountViewController")
  }
  enum CreatePost: StoryboardType {
    static let storyboardName = "CreatePost"

    static let createPostViewController = SceneType<EmbeddedSocial.CreatePostViewController>(storyboard: CreatePost.self, identifier: "CreatePostViewController")
  }
  enum EditProfile: StoryboardType {
    static let storyboardName = "EditProfile"

    static let initialScene = InitialSceneType<EmbeddedSocial.EditProfileViewController>(storyboard: EditProfile.self)

    static let editProfileViewController = SceneType<EmbeddedSocial.EditProfileViewController>(storyboard: EditProfile.self, identifier: "EditProfileViewController")
  }
  enum FeedModule: StoryboardType {
    static let storyboardName = "FeedModule"

    static let feedModuleViewController = SceneType<EmbeddedSocial.FeedModuleViewController>(storyboard: FeedModule.self, identifier: "FeedModuleViewController")
  }
  enum FollowRequests: StoryboardType {
    static let storyboardName = "FollowRequests"

    static let followRequestsViewController = SceneType<EmbeddedSocial.FollowRequestsViewController>(storyboard: FollowRequests.self, identifier: "FollowRequestsViewController")
  }
  enum Followers: StoryboardType {
    static let storyboardName = "Followers"

    static let followersViewController = SceneType<EmbeddedSocial.FollowersViewController>(storyboard: Followers.self, identifier: "FollowersViewController")
  }
  enum Following: StoryboardType {
    static let storyboardName = "Following"

    static let followingViewController = SceneType<EmbeddedSocial.FollowingViewController>(storyboard: Following.self, identifier: "FollowingViewController")
  }
  enum LikesList: StoryboardType {
    static let storyboardName = "LikesList"

    static let likesListViewController = SceneType<EmbeddedSocial.LikesListViewController>(storyboard: LikesList.self, identifier: "LikesListViewController")
  }
  enum LinkedAccounts: StoryboardType {
    static let storyboardName = "LinkedAccounts"

    static let linkedAccountsViewController = SceneType<EmbeddedSocial.LinkedAccountsViewController>(storyboard: LinkedAccounts.self, identifier: "LinkedAccountsViewController")
  }
  enum LinkedAccounts: StoryboardType {
    static let storyboardName = "LinkedAccounts"

    static let linkedAccountsViewController = SceneType<EmbeddedSocial.LinkedAccountsViewController>(storyboard: LinkedAccounts.self, identifier: "LinkedAccountsViewController")
  }
  enum Login: StoryboardType {
    static let storyboardName = "Login"

    static let initialScene = InitialSceneType<EmbeddedSocial.LoginViewController>(storyboard: Login.self)

    static let loginViewController = SceneType<EmbeddedSocial.LoginViewController>(storyboard: Login.self, identifier: "LoginViewController")
  }
  enum MenuStack: StoryboardType {
    static let storyboardName = "MenuStack"

    static let sideMenuViewController = SceneType<EmbeddedSocial.SideMenuViewController>(storyboard: MenuStack.self, identifier: "SideMenuViewController")
  }
  enum PopularModuleView: StoryboardType {
    static let storyboardName = "PopularModuleView"

    static let popularModuleView = SceneType<EmbeddedSocial.PopularModuleView>(storyboard: PopularModuleView.self, identifier: "PopularModuleView")
  }
  enum PostDetail: StoryboardType {
    static let storyboardName = "PostDetail"

    static let postDetailViewController = SceneType<EmbeddedSocial.PostDetailViewController>(storyboard: PostDetail.self, identifier: "PostDetailViewController")
  }
  enum Report: StoryboardType {
    static let storyboardName = "Report"

    static let reportSubmittedViewController = SceneType<EmbeddedSocial.ReportSubmittedViewController>(storyboard: Report.self, identifier: "ReportSubmittedViewController")

    static let reportViewController = SceneType<EmbeddedSocial.ReportViewController>(storyboard: Report.self, identifier: "ReportViewController")
  }
  enum Search: StoryboardType {
    static let storyboardName = "Search"

    static let searchViewController = SceneType<EmbeddedSocial.SearchViewController>(storyboard: Search.self, identifier: "SearchViewController")
  }
  enum SearchPeople: StoryboardType {
    static let storyboardName = "SearchPeople"

    static let searchPeopleViewController = SceneType<EmbeddedSocial.SearchPeopleViewController>(storyboard: SearchPeople.self, identifier: "SearchPeopleViewController")
  }
  enum SearchTopics: StoryboardType {
    static let storyboardName = "SearchTopics"

    static let searchTopicsViewController = SceneType<EmbeddedSocial.SearchTopicsViewController>(storyboard: SearchTopics.self, identifier: "SearchTopicsViewController")
  }
  enum Settings: StoryboardType {
    static let storyboardName = "Settings"

    static let settingsViewController = SceneType<EmbeddedSocial.SettingsViewController>(storyboard: Settings.self, identifier: "SettingsViewController")
  }
  enum SuggestedUsers: StoryboardType {
    static let storyboardName = "SuggestedUsers"

    static let suggestedUsersViewController = SceneType<EmbeddedSocial.SuggestedUsersViewController>(storyboard: SuggestedUsers.self, identifier: "SuggestedUsersViewController")
  }
  enum UserProfile: StoryboardType {
    static let storyboardName = "UserProfile"

    static let userProfileViewController = SceneType<EmbeddedSocial.UserProfileViewController>(storyboard: UserProfile.self, identifier: "UserProfileViewController")
  }
}

enum StoryboardSegue {
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

private final class BundleToken {}

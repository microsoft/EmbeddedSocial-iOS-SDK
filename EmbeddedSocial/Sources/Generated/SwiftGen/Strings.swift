// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {

  enum ActivityFeed {
    /// Activity Feed
    static let screenTitle = L10n.tr("Localizable", "activity_feed.screen_title")
  }

  enum Common {
    /// Blocked
    static let blocked = L10n.tr("Localizable", "common.blocked")
    /// Cancel
    static let cancel = L10n.tr("Localizable", "common.cancel")
    /// Close
    static let close = L10n.tr("Localizable", "common.close")
    /// Follow
    static let follow = L10n.tr("Localizable", "common.follow")
    /// Following
    static let following = L10n.tr("Localizable", "common.following")
    /// OK
    static let ok = L10n.tr("Localizable", "common.ok")
    /// Pending
    static let pending = L10n.tr("Localizable", "common.pending")

    enum Placeholder {
      /// Not specified
      static let notSpecified = L10n.tr("Localizable", "common.placeholder.not_specified")
      /// Unknown
      static let unknown = L10n.tr("Localizable", "common.placeholder.unknown")
    }
  }

  enum CreateAccount {
    /// Create an account
    static let screenTitle = L10n.tr("Localizable", "create_account.screen_title")

    enum Button {
      /// Sign up
      static let signUp = L10n.tr("Localizable", "create_account.button.sign_up")
    }
  }

  enum CreatePost {
    /// Going back to the feed will delete the content of this draft, are you sure you want to go back?
    static let leaveNewPost = L10n.tr("Localizable", "create_post.leave_new_post")
    /// Leave post
    static let leavePost = L10n.tr("Localizable", "create_post.leave_post")
    /// Post
    static let post = L10n.tr("Localizable", "create_post.post")
    /// Return to feed?
    static let returnToFeed = L10n.tr("Localizable", "create_post.return_to_feed")

    enum Button {
      /// Tap here to add a picture
      static let addPicture = L10n.tr("Localizable", "create_post.button.add_picture")
      /// Add new post
      static let addPost = L10n.tr("Localizable", "create_post.button.add_post")
    }
  }

  enum EditProfile {
    /// Edit profile
    static let screenTitle = L10n.tr("Localizable", "edit_profile.screen_title")

    enum Button {
      /// Save
      static let save = L10n.tr("Localizable", "edit_profile.button.save")
    }

    enum Label {
      /// Account Information
      static let accountInformation = L10n.tr("Localizable", "edit_profile.label.account_information")
    }

    enum Placeholder {
      /// Bio
      static let bio = L10n.tr("Localizable", "edit_profile.placeholder.bio")
      /// First name
      static let firstName = L10n.tr("Localizable", "edit_profile.placeholder.first_name")
      /// Last name
      static let lastName = L10n.tr("Localizable", "edit_profile.placeholder.last_name")
    }
  }

  enum Error {
    /// The operation has been cancelled by user.
    static let cancelledByUser = L10n.tr("Localizable", "error.cancelled_by_user")
    /// The request has failed.
    static let failedRequest = L10n.tr("Localizable", "error.failed_request")
    /// Image compression has failed.
    static let imageCompressionFailed = L10n.tr("Localizable", "error.image_compression_failed")
    /// Image is invalid
    static let invalidImage = L10n.tr("Localizable", "error.invalid_image")
    /// Last session is not available.
    static let lastSessionNotAvailable = L10n.tr("Localizable", "error.last_session_not_available")
    /// User credentials are missing.
    static let missingCredentials = L10n.tr("Localizable", "error.missing_credentials")
    /// User data is missing.
    static let missingUserData = L10n.tr("Localizable", "error.missing_user_data")
    /// No item for %@
    static func noItemFor(_ p1: String) -> String {
      return L10n.tr("Localizable", "error.no_item_for", p1)
    }
    /// No Items Received
    static let noItemsReceived = L10n.tr("Localizable", "error.no_items_received")
    /// Unknown error occurred.
    static let unknown = L10n.tr("Localizable", "error.unknown")
    /// User list module configuration error: API not set.
    static let userListNoApi = L10n.tr("Localizable", "error.user_list_no_api")
    /// User is not logged in.
    static let userNotLoggedIn = L10n.tr("Localizable", "error.user_not_logged_in")
  }

  enum Followers {
    /// Followers
    static let screenTitle = L10n.tr("Localizable", "followers.screen_title")
  }

  enum Following {
    /// Following
    static let screenTitle = L10n.tr("Localizable", "following.screen_title")
  }

  enum Home {
    /// Home
    static let screenTitle = L10n.tr("Localizable", "home.screen_title")
  }

  enum ImagePicker {
    /// Choose existing
    static let chooseExisting = L10n.tr("Localizable", "image_picker.choose_existing")
    /// Choose please
    static let choosePlease = L10n.tr("Localizable", "image_picker.choose_please")
    /// Remove photo
    static let removePhoto = L10n.tr("Localizable", "image_picker.remove_photo")
    /// Take photo
    static let takePhoto = L10n.tr("Localizable", "image_picker.take_photo")
  }

  enum Login {
    /// Sign in
    static let screenTitle = L10n.tr("Localizable", "login.screen_title")
  }

  enum MyPins {
    /// My pins
    static let screenTitle = L10n.tr("Localizable", "my_pins.screen_title")
  }

  enum Popular {
    /// Popular
    static let screenTitle = L10n.tr("Localizable", "popular.screen_title")
  }

  enum Post {
    /// %d comments
    static func commentsCount(_ p1: Int) -> String {
      return L10n.tr("Localizable", "post.comments_count", p1)
    }
    /// %d likes
    static func likesCount(_ p1: Int) -> String {
      return L10n.tr("Localizable", "post.likes_count", p1)
    }
    /// %d replies
    static func repliesCount(_ p1: Int) -> String {
      return L10n.tr("Localizable", "post.replies_count", p1)
    }
  }

  enum PostMenu {
    /// Block
    static let block = L10n.tr("Localizable", "post_menu.block")
    /// Edit post
    static let edit = L10n.tr("Localizable", "post_menu.edit")
    /// Follow
    static let follow = L10n.tr("Localizable", "post_menu.follow")
    /// Hide
    static let hide = L10n.tr("Localizable", "post_menu.hide")
    /// Remove post
    static let remove = L10n.tr("Localizable", "post_menu.remove")
    /// Report post
    static let report = L10n.tr("Localizable", "post_menu.report")
    /// Unblock
    static let unblock = L10n.tr("Localizable", "post_menu.unblock")
    /// Unfollow
    static let unfollow = L10n.tr("Localizable", "post_menu.unfollow")
  }

  enum ProfileSummary {

    enum Button {
      /// Edit profile
      static let edit = L10n.tr("Localizable", "profile_summary.button.edit")
      /// followers
      static let followers = L10n.tr("Localizable", "profile_summary.button.followers")
      /// following
      static let following = L10n.tr("Localizable", "profile_summary.button.following")
    }
  }

  enum Report {
    /// Report %@
    static func screenTitle(_ p1: String) -> String {
      return L10n.tr("Localizable", "report.screen_title", p1)
    }
  }

  enum Search {
    /// Search
    static let screenTitle = L10n.tr("Localizable", "search.screen_title")

    enum Label {
      /// Based on who you follow
      static let basedOnWhoYouFollow = L10n.tr("Localizable", "search.label.based_on_who_you_follow")
    }

    enum Placeholder {
      /// Search people
      static let searchPeople = L10n.tr("Localizable", "search.placeholder.search_people")
    }
  }

  enum Settings {
    /// Settings
    static let screenTitle = L10n.tr("Localizable", "settings.screen_title")
  }

  enum SideMenu {
    /// Debug
    static let debug = L10n.tr("Localizable", "side_menu.debug")
    /// Sign In
    static let signIn = L10n.tr("Localizable", "side_menu.sign_in")
    /// Social
    static let social = L10n.tr("Localizable", "side_menu.social")
  }

  enum UploadPhotoCell {
    /// Upload photo
    static let uploadPhoto = L10n.tr("Localizable", "upload_photo_cell.upload_photo")
  }

  enum UserProfile {
    /// Profile
    static let screenTitle = L10n.tr("Localizable", "user_profile.screen_title")

    enum Button {
      /// Add post
      static let addPost = L10n.tr("Localizable", "user_profile.button.add_post")
      /// Block user
      static let blockUser = L10n.tr("Localizable", "user_profile.button.block_user")
      /// Popular posts
      static let popularPosts = L10n.tr("Localizable", "user_profile.button.popular_posts")
      /// Recent posts
      static let recentPosts = L10n.tr("Localizable", "user_profile.button.recent_posts")
      /// Report user
      static let reportUser = L10n.tr("Localizable", "user_profile.button.report_user")
    }
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  fileprivate static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}

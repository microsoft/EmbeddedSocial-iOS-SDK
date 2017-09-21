// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {
  /// %s started following you
  static func activityYouFollowing(_ p1: UnsafePointer<unichar>) -> String {
    return L10n.tr("Localizable", "activity_you_following", p1)
  }

  enum Activity {
    /// %s replied to comment %s
    static func followingChildComment(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.following_child_comment", p1, p2)
    }
    /// %s added a new reply to comment %s
    static func followingChildPeerComment(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.following_child_peer_comment", p1, p2)
    }
    /// %s added a new comment to topic %s
    static func followingChildPeerTopic(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.following_child_peer_topic", p1, p2)
    }
    /// %s commented on topic %s
    static func followingChildTopic(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.following_child_topic", p1, p2)
    }
    /// %s started following %s
    static func followingFollowing(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.following_following", p1, p2)
    }
    /// %s liked comment %s
    static func followingLikeComment(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.following_like_comment", p1, p2)
    }
    /// %s liked reply %s
    static func followingLikeReply(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.following_like_reply", p1, p2)
    }
    /// %s liked topic %s
    static func followingLikeTopic(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.following_like_topic", p1, p2)
    }
    /// %s mentioned %s in a comment %s
    static func followingMentionComment(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>, _ p3: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.following_mention_comment", p1, p2, p3)
    }
    /// %s mentioned %s in a reply %s
    static func followingMentionReply(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>, _ p3: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.following_mention_reply", p1, p2, p3)
    }
    /// %s mentioned %s in a topic %s
    static func followingMentionTopic(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>, _ p3: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.following_mention_topic", p1, p2, p3)
    }
    /// %s, %s and %d other people
    static func manyPersons(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>, _ p3: Int) -> String {
      return L10n.tr("Localizable", "activity.many_persons", p1, p2, p3)
    }
    /// %s
    static func onePerson(_ p1: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.one_person", p1)
    }
    /// %s, %s and 1 other person
    static func threePersons(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.three_persons", p1, p2)
    }
    /// %s and %s
    static func twoPersons(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.two_persons", p1, p2)
    }
    /// %s replied to your comment %s
    static func youChildComment(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.you_child_comment", p1, p2)
    }
    /// %s added a new reply to comment %s
    static func youChildPeerComment(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.you_child_peer_comment", p1, p2)
    }
    /// %s added a new comment to topic %s
    static func youChildPeerTopic(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.you_child_peer_topic", p1, p2)
    }
    /// %s commented on your topic %s
    static func youChildTopic(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.you_child_topic", p1, p2)
    }
    /// %s accepted your follow request
    static func youFollowAccepted(_ p1: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.you_follow_accepted", p1)
    }
    /// %s sent you a follow request
    static func youFollowRequest(_ p1: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.you_follow_request", p1)
    }
    /// %s liked your comment %s
    static func youLikeComment(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.you_like_comment", p1, p2)
    }
    /// %s liked your reply %s
    static func youLikeReply(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.you_like_reply", p1, p2)
    }
    /// %s liked your topic %s
    static func youLikeTopic(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.you_like_topic", p1, p2)
    }
    /// %s mentioned you in a comment %s
    static func youMentionComment(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.you_mention_comment", p1, p2)
    }
    /// %s mentioned you in a reply %s
    static func youMentionReply(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.you_mention_reply", p1, p2)
    }
    /// %s mentioned you in a topic %s
    static func youMentionTopic(_ p1: UnsafePointer<unichar>, _ p2: UnsafePointer<unichar>) -> String {
      return L10n.tr("Localizable", "activity.you_mention_topic", p1, p2)
    }
  }

  enum ActivityFeed {
    /// Activity Feed
    static let screenTitle = L10n.tr("Localizable", "activity_feed.screen_title")
  }

  enum BlockedUsers {
    /// Blocked users
    static let screenTitle = L10n.tr("Localizable", "blocked_users.screen_title")
  }

  enum Common {
    /// Blocked
    static let blocked = L10n.tr("Localizable", "common.blocked")
    /// Cancel
    static let cancel = L10n.tr("Localizable", "common.cancel")
    /// Close
    static let close = L10n.tr("Localizable", "common.close")
    /// Done
    static let done = L10n.tr("Localizable", "common.done")
    /// Follow
    static let follow = L10n.tr("Localizable", "common.follow")
    /// Following
    static let following = L10n.tr("Localizable", "common.following")
    /// OK
    static let ok = L10n.tr("Localizable", "common.ok")
    /// Pending
    static let pending = L10n.tr("Localizable", "common.pending")
    /// Submit
    static let submit = L10n.tr("Localizable", "common.submit")
    /// Unblock
    static let unblock = L10n.tr("Localizable", "common.unblock")

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
    /// Save
    static let save = L10n.tr("Localizable", "create_post.save")

    enum Button {
      /// Tap here to add a picture
      static let addPicture = L10n.tr("Localizable", "create_post.button.add_picture")
      /// Add new post
      static let addPost = L10n.tr("Localizable", "create_post.button.add_post")
      /// Update post
      static let updatePost = L10n.tr("Localizable", "create_post.button.update_post")
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

  enum LikesList {
    /// Like this post
    static let screenTitle = L10n.tr("Localizable", "likes_list.screen_title")
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

  enum PopularModule {

    enum FeedOption {
      /// All time
      static let allTime = L10n.tr("Localizable", "popular_module.feed_option.all_time")
      /// This week
      static let thisWeek = L10n.tr("Localizable", "popular_module.feed_option.this_week")
      /// Today
      static let today = L10n.tr("Localizable", "popular_module.feed_option.today")
    }
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
    ///  ... Read More
    static let readMore = L10n.tr("Localizable", "post.read_more")
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
    /// Remove comment
    static let removeComment = L10n.tr("Localizable", "post_menu.remove_comment")
    /// Remove reply
    static let removeReply = L10n.tr("Localizable", "post_menu.remove_reply")
    /// Report post
    static let report = L10n.tr("Localizable", "post_menu.report")
    /// Report comment
    static let reportComment = L10n.tr("Localizable", "post_menu.report_comment")
    /// Report reply
    static let reportReply = L10n.tr("Localizable", "post_menu.report_reply")
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
    /// Report an issue
    static let screenTitle = L10n.tr("Localizable", "report.screen_title")

    enum Comment {
      /// What's the problem with this comment?
      static let headerTitle = L10n.tr("Localizable", "report.comment.header_title")
    }

    enum Post {
      /// What's the problem with this post?
      static let headerTitle = L10n.tr("Localizable", "report.post.header_title")
    }

    enum Reply {
      /// What's the problem with this reply?
      static let headerTitle = L10n.tr("Localizable", "report.reply.header_title")
    }

    enum User {
      /// What's the problem with this account?
      static let headerTitle = L10n.tr("Localizable", "report.user.header_title")
    }
  }

  enum Search {
    /// Search
    static let screenTitle = L10n.tr("Localizable", "search.screen_title")

    enum Filter {
      /// People
      static let people = L10n.tr("Localizable", "search.filter.people")
      /// Topics
      static let topics = L10n.tr("Localizable", "search.filter.topics")
    }

    enum Label {
      /// Based on who you follow
      static let basedOnWhoYouFollow = L10n.tr("Localizable", "search.label.based_on_who_you_follow")
    }

    enum Placeholder {
      /// Search people
      static let searchPeople = L10n.tr("Localizable", "search.placeholder.search_people")
      /// Search topics
      static let searchTopics = L10n.tr("Localizable", "search.placeholder.search_topics")
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

// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {

  enum Activity {
    /// %@, %@ and %d other people
    static func manyPersons(_ p1: String, _ p2: String, _ p3: Int) -> String {
      return L10n.tr("Localizable", "activity.many_persons", p1, p2, p3)
    }
    /// %@
    static func onePerson(_ p1: String) -> String {
      return L10n.tr("Localizable", "activity.one_person", p1)
    }
    /// %@, %@ and 1 other person
    static func threePersons(_ p1: String, _ p2: String) -> String {
      return L10n.tr("Localizable", "activity.three_persons", p1, p2)
    }
    /// %@ and %@
    static func twoPersons(_ p1: String, _ p2: String) -> String {
      return L10n.tr("Localizable", "activity.two_persons", p1, p2)
    }

    enum Following {
      /// %@ replied to comment "%@".
      static func childComment(_ p1: String, _ p2: String) -> String {
        return L10n.tr("Localizable", "activity.following.child_comment", p1, p2)
      }
      /// %@ added a new reply to comment "%@".
      static func childPeerComment(_ p1: String, _ p2: String) -> String {
        return L10n.tr("Localizable", "activity.following.child_peer_comment", p1, p2)
      }
      /// %@ added a new comment to topic "%@".
      static func childPeerTopic(_ p1: String, _ p2: String) -> String {
        return L10n.tr("Localizable", "activity.following.child_peer_topic", p1, p2)
      }
      /// %@ commented on topic "%@".
      static func childTopic(_ p1: String, _ p2: String) -> String {
        return L10n.tr("Localizable", "activity.following.child_topic", p1, p2)
      }
      /// %@ started following %@
      static func following(_ p1: String, _ p2: String) -> String {
        return L10n.tr("Localizable", "activity.following.following", p1, p2)
      }
      /// %@ liked comment "%@".
      static func likeComment(_ p1: String, _ p2: String) -> String {
        return L10n.tr("Localizable", "activity.following.like_comment", p1, p2)
      }
      /// %@ liked reply "%@".
      static func likeReply(_ p1: String, _ p2: String) -> String {
        return L10n.tr("Localizable", "activity.following.like_reply", p1, p2)
      }
      /// %@ liked topic "%@".
      static func likeTopic(_ p1: String, _ p2: String) -> String {
        return L10n.tr("Localizable", "activity.following.like_topic", p1, p2)
      }
      /// %@ mentioned %@ in a comment "%@".
      static func mentionComment(_ p1: String, _ p2: String, _ p3: String) -> String {
        return L10n.tr("Localizable", "activity.following.mention_comment", p1, p2, p3)
      }
      /// %@ mentioned %@ in a reply "%@".
      static func mentionReply(_ p1: String, _ p2: String, _ p3: String) -> String {
        return L10n.tr("Localizable", "activity.following.mention_reply", p1, p2, p3)
      }
      /// %@ mentioned %@ in a topic "%@".
      static func mentionTopic(_ p1: String, _ p2: String, _ p3: String) -> String {
        return L10n.tr("Localizable", "activity.following.mention_topic", p1, p2, p3)
      }
    }

    enum Sections {

      enum My {
        /// RECENT ACTIVITY
        static let title = L10n.tr("Localizable", "activity.sections.my.title")
      }

      enum Others {
        /// RECENT ACTIVITY
        static let title = L10n.tr("Localizable", "activity.sections.others.title")
      }

      enum Pending {
        /// NEW FOLLOW REQUESTS
        static let title = L10n.tr("Localizable", "activity.sections.pending.title")
      }
    }

    enum Tabs {
      /// You
      static let myTitle = L10n.tr("Localizable", "activity.tabs.my_title")
      /// Following
      static let othersTitle = L10n.tr("Localizable", "activity.tabs.others_title")
    }

    enum Views {

      enum Main {
        /// Activity Feed
        static let title = L10n.tr("Localizable", "activity.views.main.title")
      }
    }

    enum You {
      /// %@ replied to your comment "%@".
      static func childComment(_ p1: String, _ p2: String) -> String {
        return L10n.tr("Localizable", "activity.you.child_comment", p1, p2)
      }
      /// %@ added a new reply to comment "%@".
      static func childPeerComment(_ p1: String, _ p2: String) -> String {
        return L10n.tr("Localizable", "activity.you.child_peer_comment", p1, p2)
      }
      /// %@ added a new comment to topic "%@".
      static func childPeerTopic(_ p1: String, _ p2: String) -> String {
        return L10n.tr("Localizable", "activity.you.child_peer_topic", p1, p2)
      }
      /// %@ commented on your topic "%@".
      static func childTopic(_ p1: String, _ p2: String) -> String {
        return L10n.tr("Localizable", "activity.you.child_topic", p1, p2)
      }
      /// %@ accepted your follow request.
      static func followAccepted(_ p1: String) -> String {
        return L10n.tr("Localizable", "activity.you.follow_accepted", p1)
      }
      /// %@ sent you a follow request.
      static func followRequest(_ p1: String) -> String {
        return L10n.tr("Localizable", "activity.you.follow_request", p1)
      }
      /// %@ started following you.
      static func following(_ p1: String) -> String {
        return L10n.tr("Localizable", "activity.you.following", p1)
      }
      /// %@ liked your comment "%@".
      static func likeComment(_ p1: String, _ p2: String) -> String {
        return L10n.tr("Localizable", "activity.you.like_comment", p1, p2)
      }
      /// %@ liked your reply "%@".
      static func likeReply(_ p1: String, _ p2: String) -> String {
        return L10n.tr("Localizable", "activity.you.like_reply", p1, p2)
      }
      /// %@ liked your topic "%@".
      static func likeTopic(_ p1: String, _ p2: String) -> String {
        return L10n.tr("Localizable", "activity.you.like_topic", p1, p2)
      }
      /// %@ mentioned you in a comment "%@".
      static func mentionComment(_ p1: String, _ p2: String) -> String {
        return L10n.tr("Localizable", "activity.you.mention_comment", p1, p2)
      }
      /// %@ mentioned you in a reply "%@".
      static func mentionReply(_ p1: String, _ p2: String) -> String {
        return L10n.tr("Localizable", "activity.you.mention_reply", p1, p2)
      }
      /// %@ mentioned you in a topic "%@".
      static func mentionTopic(_ p1: String, _ p2: String) -> String {
        return L10n.tr("Localizable", "activity.you.mention_topic", p1, p2)
      }
    }
  }

  enum ActivityFeed {
    /// Activity Feed
    static let screenTitle = L10n.tr("Localizable", "activity_feed.screen_title")
  }

  enum BlockedUsers {
    /// You haven't blocked anyone.
    static let noDataText = L10n.tr("Localizable", "blocked_users.no_data_text")
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
    /// No content
    static let noContent = L10n.tr("Localizable", "common.no_content")
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
    /// Text
    static let bodyPlaceholder = L10n.tr("Localizable", "create_post.body_placeholder")
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
    /// Title
    static let titlePlaceholder = L10n.tr("Localizable", "create_post.title_placeholder")

    enum Button {
      /// Tap here to add a picture
      static let addPicture = L10n.tr("Localizable", "create_post.button.add_picture")
      /// Add new post
      static let addPost = L10n.tr("Localizable", "create_post.button.add_post")
      /// Update post
      static let updatePost = L10n.tr("Localizable", "create_post.button.update_post")
    }
  }

  enum DetailedActivity {

    enum Button {
      /// Open comment
      static let openComment = L10n.tr("Localizable", "detailed_activity.button.open_comment")
      /// Open topic
      static let openTopic = L10n.tr("Localizable", "detailed_activity.button.open_topic")
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
    /// Comment not found
    static let commentNotFound = L10n.tr("Localizable", "error.comment_not_found")
    /// The request has failed.
    static let failedRequest = L10n.tr("Localizable", "error.failed_request")
    /// Image compression has failed.
    static let imageCompressionFailed = L10n.tr("Localizable", "error.image_compression_failed")
    /// Image is invalid
    static let invalidImage = L10n.tr("Localizable", "error.invalid_image")
    /// Invalid server response.
    static let invalidResponse = L10n.tr("Localizable", "error.invalid_response")
    /// Last session is not available.
    static let lastSessionNotAvailable = L10n.tr("Localizable", "error.last_session_not_available")
    /// User credentials are missing.
    static let missingCredentials = L10n.tr("Localizable", "error.missing_credentials")
    /// Cant handle response, data is corrupted.
    static let missingResponseData = L10n.tr("Localizable", "error.missing_response_data")
    /// User data is missing.
    static let missingUserData = L10n.tr("Localizable", "error.missing_user_data")
    /// No internet connection. You can still post while offline.
    static let noInternetConnection = L10n.tr("Localizable", "error.no_internet_connection")
    /// No item for %@
    static func noItemFor(_ p1: String) -> String {
      return L10n.tr("Localizable", "error.no_item_for", p1)
    }
    /// No Items Received
    static let noItemsReceived = L10n.tr("Localizable", "error.no_items_received")
    /// Internet connection is not available.
    static let notConnectedToInternet = L10n.tr("Localizable", "error.not_connected_to_internet")
    /// Not implemented.
    static let notImplemented = L10n.tr("Localizable", "error.not_implemented")
    /// Unknown error occurred.
    static let unknown = L10n.tr("Localizable", "error.unknown")
    /// User list module configuration error: API not set.
    static let userListNoApi = L10n.tr("Localizable", "error.user_list_no_api")
    /// User is not logged in.
    static let userNotLoggedIn = L10n.tr("Localizable", "error.user_not_logged_in")
  }

  enum FollowRequests {
    /// No follow requests to show.
    static let noDataText = L10n.tr("Localizable", "follow_requests.no_data_text")
    /// New follow requests
    static let screenTitle = L10n.tr("Localizable", "follow_requests.screen_title")
  }

  enum Followers {
    /// Currently nobody is following you.
    static let noDataText = L10n.tr("Localizable", "followers.no_data_text")
    /// Followers
    static let screenTitle = L10n.tr("Localizable", "followers.screen_title")
  }

  enum Following {
    /// Currently you are not following anyone.
    static let noDataText = L10n.tr("Localizable", "following.no_data_text")
    /// Following
    static let screenTitle = L10n.tr("Localizable", "following.screen_title")
    /// Search people
    static let searchPeople = L10n.tr("Localizable", "following.search_people")
    /// Suggested users
    static let suggestedUsers = L10n.tr("Localizable", "following.suggested_users")
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

    enum Comment {
      /// No one has liked this comment yet.
      static let noDataText = L10n.tr("Localizable", "likes_list.comment.no_data_text")
    }

    enum Post {
      /// No one has liked this post yet.
      static let noDataText = L10n.tr("Localizable", "likes_list.post.no_data_text")
    }

    enum Reply {
      /// No one has liked this reply yet.
      static let noDataText = L10n.tr("Localizable", "likes_list.reply.no_data_text")
    }
  }

  enum LinkedAccounts {
    /// Linked accounts
    static let screenTitle = L10n.tr("Localizable", "linked_accounts.screen_title")
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

  enum PostDetails {
    /// Type here to comment on this post
    static let commentPlaceholder = L10n.tr("Localizable", "post_details.comment_placeholder")
  }
    
  enum CommentReplies {
    /// Type here to reply on this comment
    static let replyPlaceholder = L10n.tr("Localizable", "comment_replies.reply_placeholder")
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
      /// Trending topics
      static let trendingTopics = L10n.tr("Localizable", "search.label.trending_topics")
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

  enum SuggestedUsers {
    /// No suggested users to show.
    static let noDataText = L10n.tr("Localizable", "suggested_users.no_data_text")
    /// Suggested users
    static let screenTitle = L10n.tr("Localizable", "suggested_users.screen_title")
  }

  enum UploadPhotoCell {
    /// Upload photo
    static let uploadPhoto = L10n.tr("Localizable", "upload_photo_cell.upload_photo")
  }

  enum UserProfile {
    /// This user is private.
    static let privateFeed = L10n.tr("Localizable", "user_profile.private_feed")
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

// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  typealias Image = UIImage
#elseif os(OSX)
  import AppKit.NSImage
  typealias Image = NSImage
#endif

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum Asset: String {
  case esAccept = "es_accept"
  case esDecorComment = "es_decor_comment"
  case esDecorFollow = "es_decor_follow"
  case esDecorLike = "es_decor_like"
  case esReject = "es_reject"
  case iconDesignObserver = "icon_designObserver"
  case iconFb = "icon_fb"
  case iconFreshPaint = "icon_freshPaint"
  case iconGplus = "icon_gplus"
  case iconMsft = "icon_msft"
  case iconSocialPlusV2 = "icon_socialPlus_v2"
  case iconTwitter = "icon_twitter"
  case iconAccept = "icon_accept"
  case iconActivityActive = "icon_activity_active"
  case iconActivityCommented = "icon_activity_commented"
  case iconActivityFollowed = "icon_activity_followed"
  case iconActivityLiked = "icon_activity_liked"
  case iconActivity = "icon_activity"
  case iconArrowGreen = "icon_arrow_green"
  case iconBack = "icon_back"
  case iconCheckmarkBlue = "icon_checkmark_blue"
  case iconCommentActive = "icon_comment_active"
  case iconComment = "icon_comment"
  case iconDisclosure = "icon_disclosure"
  case iconDots = "icon_dots"
  case iconEdit = "icon_edit"
  case iconGallery = "icon_gallery"
  case iconGear = "icon_gear"
  case iconHamburger = "icon_hamburger"
  case iconHomeActive = "icon_home_active"
  case iconHome = "icon_home"
  case iconLikedActive = "icon_liked_active"
  case iconLiked = "icon_liked"
  case iconList = "icon_list"
  case iconLogout = "icon_logout"
  case iconPinActive = "icon_pin_active"
  case iconPin = "icon_pin"
  case iconPinsActive = "icon_pins_active"
  case iconPins = "icon_pins"
  case iconPopularActive = "icon_popular_active"
  case iconPopular = "icon_popular"
  case iconPrivate = "icon_private"
  case iconRecentSearch = "icon_recentSearch"
  case iconReject = "icon_reject"
  case iconSearchActive = "icon_search_active"
  case iconSearch = "icon_search"
  case iconSettingsActive = "icon_settings_active"
  case iconSettings = "icon_settings"
  case logoWhite = "logo-white"
  case logo = "logo"
  case placeholderPostImage = "placeholder_post_image"
  case placeholderPostImage2 = "placeholder_post_image2"
  case placeholderPostNoimage = "placeholder_post_noimage"
  case placeholderPostUser1 = "placeholder_post_user_1"
  case userPhotoPlaceholder = "user_photo_placeholder"

  var image: Image {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = Image(named: rawValue, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: rawValue)
    #elseif os(watchOS)
    let image = Image(named: rawValue)
    #endif
    guard let result = image else { fatalError("Unable to load image \(rawValue).") }
    return result
  }
}
// swiftlint:enable type_body_length

extension Image {
  convenience init!(asset: Asset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.rawValue, in: bundle, compatibleWith: nil)
    #elseif os(OSX) || os(watchOS)
    self.init(named: asset.rawValue)
    #endif
  }
}

private final class BundleToken {}

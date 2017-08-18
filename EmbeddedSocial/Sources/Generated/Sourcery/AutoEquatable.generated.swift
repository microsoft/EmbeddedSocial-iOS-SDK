// Generated using Sourcery 0.7.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable file_length
fileprivate func compareOptionals<T>(lhs: T?, rhs: T?, compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    switch (lhs, rhs) {
    case let (lValue?, rValue?):
        return compare(lValue, rValue)
    case (nil, nil):
        return true
    default:
        return false
    }
}

fileprivate func compareArrays<T>(lhs: [T], rhs: [T], compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for (idx, lhsItem) in lhs.enumerated() {
        guard compare(lhsItem, rhs[idx]) else { return false }
    }

    return true
}


// MARK: - AutoEquatable for classes, protocols, structs
// MARK: - APIError AutoEquatable
extension APIError: Equatable {}
 func == (lhs: APIError, rhs: APIError) -> Bool {
    return true
}
// MARK: - CredentialsList AutoEquatable
extension CredentialsList: Equatable {}
internal func == (lhs: CredentialsList, rhs: CredentialsList) -> Bool {
    guard lhs.provider == rhs.provider else { return false }
    guard lhs.accessToken == rhs.accessToken else { return false }
    guard compareOptionals(lhs: lhs.requestToken, rhs: rhs.requestToken, compare: ==) else { return false }
    guard lhs.appKey == rhs.appKey else { return false }
    guard lhs.socialUID == rhs.socialUID else { return false }
    return true
}
// MARK: - Photo AutoEquatable
extension Photo: Equatable {}
internal func == (lhs: Photo, rhs: Photo) -> Bool {
    guard lhs.uid == rhs.uid else { return false }
    guard compareOptionals(lhs: lhs.url, rhs: rhs.url, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.image, rhs: rhs.image, compare: ==) else { return false }
    return true
}
// MARK: - Post AutoEquatable
extension Post: Equatable {}
internal func == (lhs: Post, rhs: Post) -> Bool {
    guard compareOptionals(lhs: lhs.topicHandle, rhs: rhs.topicHandle, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.createdTime, rhs: rhs.createdTime, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.userHandle, rhs: rhs.userHandle, compare: ==) else { return false }
    guard lhs.userStatus == rhs.userStatus else { return false }
    guard compareOptionals(lhs: lhs.firstName, rhs: rhs.firstName, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.lastName, rhs: rhs.lastName, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.photoHandle, rhs: rhs.photoHandle, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.photoUrl, rhs: rhs.photoUrl, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.title, rhs: rhs.title, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.text, rhs: rhs.text, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.imageUrl, rhs: rhs.imageUrl, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.deepLink, rhs: rhs.deepLink, compare: ==) else { return false }
    guard lhs.totalLikes == rhs.totalLikes else { return false }
    guard lhs.totalComments == rhs.totalComments else { return false }
    guard lhs.liked == rhs.liked else { return false }
    guard lhs.pinned == rhs.pinned else { return false }
    return true
}
// MARK: - SocialUser AutoEquatable
extension SocialUser: Equatable {}
internal func == (lhs: SocialUser, rhs: SocialUser) -> Bool {
    guard lhs.uid == rhs.uid else { return false }
    guard compareOptionals(lhs: lhs.firstName, rhs: rhs.firstName, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.lastName, rhs: rhs.lastName, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.email, rhs: rhs.email, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.bio, rhs: rhs.bio, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.photo, rhs: rhs.photo, compare: ==) else { return false }
    guard lhs.credentials == rhs.credentials else { return false }
    return true
}
// MARK: - User AutoEquatable
extension User: Equatable {}
internal func == (lhs: User, rhs: User) -> Bool {
    guard lhs.uid == rhs.uid else { return false }
    guard compareOptionals(lhs: lhs.firstName, rhs: rhs.firstName, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.lastName, rhs: rhs.lastName, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.email, rhs: rhs.email, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.bio, rhs: rhs.bio, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.photo, rhs: rhs.photo, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.credentials, rhs: rhs.credentials, compare: ==) else { return false }
    guard lhs.followersCount == rhs.followersCount else { return false }
    guard lhs.followingCount == rhs.followingCount else { return false }
    guard compareOptionals(lhs: lhs.visibility, rhs: rhs.visibility, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.followerStatus, rhs: rhs.followerStatus, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.followingStatus, rhs: rhs.followingStatus, compare: ==) else { return false }
    return true
}
// MARK: - UsersListResponse AutoEquatable
extension UsersListResponse: Equatable {}
 func == (lhs: UsersListResponse, rhs: UsersListResponse) -> Bool {
    return true
}

// MARK: - AutoEquatable for Enums

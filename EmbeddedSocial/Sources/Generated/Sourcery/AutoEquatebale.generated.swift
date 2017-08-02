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
// MARK: - Post AutoEquatable
extension Post: Equatable {}
internal func == (lhs: Post, rhs: Post) -> Bool {
    guard compareOptionals(lhs: lhs.topicHandle, rhs: rhs.topicHandle, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.createdTime, rhs: rhs.createdTime, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.userHandle, rhs: rhs.userHandle, compare: ==) else { return false }
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
    guard compareOptionals(lhs: lhs.liked, rhs: rhs.liked, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.pinned, rhs: rhs.pinned, compare: ==) else { return false }
    return true
}

// MARK: - AutoEquatable for Enums

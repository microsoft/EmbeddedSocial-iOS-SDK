//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import TTTAttributedLabel

protocol FeedTextLabelHandler: class {
    
    func didTapHashtag(string: String)
    func didTapReadMore()
    
}

protocol FeedTextLabelProtocol {
    func setFeedText(_ text: String, shouldTrim: Bool)
    var eventHandler: FeedTextLabelHandler? { get set }
}

class FeedTextLabel: CopyableLabel, TTTAttributedLabelDelegate, FeedTextLabelProtocol {
    
    weak var eventHandler: FeedTextLabelHandler?
    
    var textAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 12)
    ]
    
    var tagAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.boldSystemFont(ofSize: 12),
        .foregroundColor: Palette.green,
        .underlineStyle: []
    ]
    
    var showMoreAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.boldSystemFont(ofSize: 12),
        .foregroundColor: Palette.defaultTint,
        .underlineStyle: [],
        .link: URL(string: "__showmore__")!
    ]
    
    var shouldTrim = false
    var showMoreText = L10n.Post.readMore
    
    private var cachedText: String = ""
    
    var trimmedMaxLines = Constants.FeedModule.Collection.Cell.trimmedMaxLines
    var defaultMaxLines = Constants.FeedModule.Collection.Cell.maxLines
    private static let pattern = "#+[A-Za-z0-9-_]+\\b"
    private static let regex: NSRegularExpression = {
        return try! NSRegularExpression(pattern: pattern)
    }()
    
    func setFeedText(_ text: String, shouldTrim: Bool = false) {
        
        guard cachedText != text else {
            return
        }
        
        self.shouldTrim = shouldTrim
        
        cachedText = text
        
        numberOfLines = shouldTrim ? trimmedMaxLines : defaultMaxLines
        
        let attributedString = NSMutableAttributedString(string: text)

        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttributes(textAttributes, range: range)
        
        let tags = processTags(cachedText)
        applyTags(tags, with: attributedString)
        
        setupShowMore()
    }
    
    private func processTags(_ text: String) -> [NSTextCheckingResult] {
        let range = NSRange(text.startIndex..., in: text)
        let results = FeedTextLabel.regex.matches(in: text,
                                                  options: [],
                                                  range: range)
        return results
    }
    
    private func setupShowMore() {
        
        guard shouldTrim else {
            return
        }
    
        linkAttributes = nil
        activeLinkAttributes = nil
        attributedTruncationToken = NSMutableAttributedString(
            string: showMoreText,
            attributes: showMoreAttributes)
    }
    
    private func applyTags(_ tags: [NSTextCheckingResult], with string: NSMutableAttributedString) {
        
        setText(string)
        
        tags.forEach {
            
            let link = TTTAttributedLabelLink(attributes: tagAttributes,
                                              activeAttributes: tagAttributes,
                                              inactiveAttributes: tagAttributes,
                                              textCheckingResult: $0)
            
            addLink(link)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
    deinit {
        delegate = self
    }
    
    // MARK: Delegation
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith result: NSTextCheckingResult!) {
        
        let match = (cachedText as NSString).substring(with: result.range)
        eventHandler?.didTapHashtag(string: match)
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        eventHandler?.didTapReadMore()
    }
    
}

extension FeedTextLabel: Themeable {
    
    func apply(theme: Theme?) {
        guard let palette = theme?.palette else {
            return
        }
        
        tagAttributes[.foregroundColor] = palette.accent
    }
}

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

class FeedTextLabel: TTTAttributedLabel, TTTAttributedLabelDelegate, FeedTextLabelProtocol {
    
    weak var eventHandler: FeedTextLabelHandler?
    
    var textAttributes: [String: Any] = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 12)
    ]
    
    var tagAttributes: [AnyHashable: Any] = [
        NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12),
        NSForegroundColorAttributeName: Palette.green,
        NSUnderlineStyleAttributeName: NSUnderlineStyle.styleNone.rawValue
    ]
    
    var showMoreAttributes: [String: Any] = [
        NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12),
        NSForegroundColorAttributeName: Palette.defaultTint,
        NSUnderlineStyleAttributeName: NSUnderlineStyle.styleNone.rawValue,
        NSLinkAttributeName: URL(string: "__showmore__")!
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
        
        numberOfLines = self.shouldTrim ? trimmedMaxLines : defaultMaxLines
        
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttributes(textAttributes, range: NSMakeRange(0, text.characters.count))
        
        let tags = processTags(cachedText)
        applyTags(tags, with: attributedString)
        
        self.setupShowMore()
    }
    
    private func processTags(_ text: String) -> [NSTextCheckingResult] {
        let results = FeedTextLabel.regex.matches(in: text,
                                                  options: [],
                                                  range: NSMakeRange(0, text.characters.count))
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
        
        tagAttributes[NSForegroundColorAttributeName] = palette.accent
    }
}

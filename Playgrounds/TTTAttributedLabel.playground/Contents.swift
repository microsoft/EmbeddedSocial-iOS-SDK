import PlaygroundSupport

import TTTAttributedLabel

//

protocol FeedTextLabelHandler: class {
    
    func didTapHashtag(string: String)
    func didTapReadMore()
    
}

protocol FeedTextLabelProtocol {
    func setFeedText(_ text: String)
    var eventHandler: FeedTextLabelHandler? { get set }
}

class FeedTextLabel: TTTAttributedLabel, TTTAttributedLabelDelegate, FeedTextLabelProtocol {
    
    weak var eventHandler: FeedTextLabelHandler?
    
    var tagAttributes: [AnyHashable: Any] = [
        NSBackgroundColorAttributeName: UIColor.yellow,
        NSUnderlineStyleAttributeName: NSUnderlineStyle.styleNone.rawValue
    ]
    
    var showMoreAttributes: [String: Any] = [
        NSForegroundColorAttributeName: UIColor.blue,
        NSUnderlineStyleAttributeName: NSUnderlineStyle.styleNone.rawValue,
        NSLinkAttributeName: URL(string: "__showmore__")!
    ]

    var shouldTrim = false
    var showMoreText = "...Show More"

    private var cachedText: String = ""
    
    var maxLines = 10
    private static let pattern = "#+[A-Za-z0-9-_]+\\b"
    private static let regex: NSRegularExpression = {
        return try! NSRegularExpression(pattern: pattern)
    }()
    
    func setFeedText(_ text: String) {
        
        guard cachedText != text else {
            return
        }
        
        backgroundColor = UIColor.white
        
        cachedText = text
        
        numberOfLines = maxLines
        
        let attributedString = NSMutableAttributedString(string: text)

        let tags = processTags(cachedText)
        applyTags(tags, to: attributedString)
        
        self.setText(attributedText)
        self.setupShowMore()
    }
    
    private func processTags(_ text: String) -> [NSTextCheckingResult] {
        let results = FeedTextLabel.regex.matches(in: text,
                                    options: [],
                                    range: NSMakeRange(0, text.characters.count))
        return results
    }
    
    private func setupShowMore() {
        linkAttributes = nil
        activeLinkAttributes = nil
        attributedTruncationToken = NSMutableAttributedString(
            string: showMoreText,
            attributes: showMoreAttributes)
    }

    private func applyTags(_ tags: [NSTextCheckingResult], to string: NSMutableAttributedString) {
        
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


class Handler: NSObject, TTTAttributedLabelDelegate {
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith result: NSTextCheckingResult!) {
        
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        print(url)
    }
}

var originalText = "Alice was beginning to get her first #ios task in #google. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure"

var shortText = originalText


let attributedText = NSMutableAttributedString(string: shortText)

let f = CGRect(x: 0, y: 0, width: 300, height: 200)
let container = UIView(frame: f)
container.backgroundColor = UIColor.white


let handler = Handler()
var v = TTTAttributedLabel(frame: .zero)
v.delegate = handler
v.backgroundColor = UIColor.white
v.numberOfLines = 3
v.translatesAutoresizingMaskIntoConstraints = false
v.backgroundColor = .gray
//v.attributedTruncationToken = NSAttributedString(string: "... SHOW MORE")
v.linkAttributes = nil
v.activeLinkAttributes = nil

let showMoreToken = URL(string: "showmore")!


v.attributedTruncationToken = NSMutableAttributedString(
    string: "... Show more",
    attributes: [
        NSForegroundColorAttributeName: UIColor.blue,
        NSUnderlineStyleAttributeName: NSUnderlineStyle.styleNone.rawValue,
        NSLinkAttributeName: showMoreToken])


let feedTextLabel = FeedTextLabel(frame: .zero)
feedTextLabel.setFeedText(originalText)
feedTextLabel.translatesAutoresizingMaskIntoConstraints = false
feedTextLabel.backgroundColor = .gray

v = feedTextLabel
container.addSubview(v)

v.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 5).isActive = true
v.topAnchor.constraint(equalTo: container.topAnchor, constant: 5).isActive = true
v.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5).isActive = true

container.setNeedsLayout()
container.layoutIfNeeded()

let pattern = "#+[A-Za-z0-9-_]+\\b"
let regex = try? NSRegularExpression(pattern: pattern)
let results = regex!.matches(in: shortText, options: [], range: NSMakeRange(0, shortText.characters.count))

let ranges = results.map { $0.range }


for result in results {

    attributedText.addAttribute(NSBackgroundColorAttributeName,
                                value: UIColor.yellow,
                                range: result.range)
}


v.setText(attributedText)


//v.attributedTruncationToken = NSAttributedString(string: "... Show More")

results.forEach {
    
    let attributes: [AnyHashable: Any] = [
        NSBackgroundColorAttributeName: UIColor.yellow,
        NSUnderlineStyleAttributeName: NSUnderlineStyle.styleNone.rawValue]
    
    let l = TTTAttributedLabelLink(attributes: attributes,
                                   activeAttributes: attributes,
                                   inactiveAttributes: attributes,
                                   textCheckingResult: $0)
    
    v.addLink(l)
}

let size = v.bounds
let textSize = attributedText.boundingRect(
    with: CGSize(width: size.width, height: .greatestFiniteMagnitude),
    options: [.usesLineFragmentOrigin, .usesFontLeading],
    context: nil)

let textSize2 = TTTAttributedLabel.sizeThatFitsAttributedString(
    attributedText,
    withConstraints: CGSize(width: size.width, height: .greatestFiniteMagnitude),
    limitedToNumberOfLines: 10)



PlaygroundPage.current.liveView = container

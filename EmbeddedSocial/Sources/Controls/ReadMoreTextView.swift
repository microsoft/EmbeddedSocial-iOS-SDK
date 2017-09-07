//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class ReadMoreTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupDefaults()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDefaults()
    }
    
    var readMoreTapHandle: ((Void) -> Void)?
    
    func setupDefaults() {
        let readMoreText = L10n.Post.readMore
    
        isScrollEnabled = false
        isEditable = false
        isSelectable = false
    
        self.attributedReadMoreText = attributedStringForMoreText(readMoreText)
    }

    var maximumNumberOfLines: Int = 0 {
        didSet {
            _originalMaximumNumberOfLines = maximumNumberOfLines
            setNeedsLayout()
        }
    }

    var readMoreText: String? {
        get {
            return attributedReadMoreText?.string
        }
        set {
            if let text = newValue {
                attributedReadMoreText = attributedStringForMoreText(text)
            } else {
                attributedReadMoreText = nil
            }
        }
    }
    
    var attributedReadMoreText: NSAttributedString? {
        didSet {
            setNeedsLayout()
        }
    }
    
    var isTrimmed: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    var readMoreTextPadding: UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    override var text: String! {
        didSet {
            if let text = text {
                _originalAttributedText = attributedStringWithDefaultAttributes(from: text)
            } else {
                _originalAttributedText = nil
            }
        }
    }
    
    override var attributedText: NSAttributedString! {
        didSet {
            _originalAttributedText = attributedText
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        attributedText = _originalAttributedText
        if isTrimmed {
            showLessText()
        }
    }
    
    override var intrinsicContentSize : CGSize {
        textContainer.size = CGSize(width: bounds.size.width, height: CGFloat.greatestFiniteMagnitude)
        var intrinsicContentSize = layoutManager.boundingRect(forGlyphRange: layoutManager.glyphRange(for: textContainer), in: textContainer).size
        intrinsicContentSize.width = UIViewNoIntrinsicMetric
        intrinsicContentSize.height += (textContainerInset.top + textContainerInset.bottom)
        intrinsicContentSize.height = ceil(intrinsicContentSize.height)
        return intrinsicContentSize
    }
    
    private var intrinsicContentHeight: CGFloat {
        return intrinsicContentSize.height
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return hitTest(pointInGliphRange: point, event: event) { _ in
            guard pointsToReadMore(point: point) == true else { return nil }
            return self
        }
    }
    
    private func pointsToReadMore(point: CGPoint) -> Bool {
        return pointIsInTextRange(point: point, range: readMoreTextRange(), padding: readMoreTextPadding)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self) {
            if pointsToReadMore(point: point) {
                readMoreTapHandle?()
            }
        }
        super.touchesEnded(touches, with: event)
    }
    
    // MARK: Private
    
    private var _originalMaximumNumberOfLines: Int = 0
    private var _originalAttributedText: NSAttributedString!
    private var _originalTextLength: Int {
        get {
            return _originalAttributedText?.length ?? 0
        }
    }
    
    private func attributedStringWithDefaultAttributes(from text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [
            NSFontAttributeName: font ?? UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: textColor ?? UIColor.black
            ])
    }
    
    private func attributedStringForMoreText(_ text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [
            NSFontAttributeName: font ?? UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: textColor ?? UIColor.darkGray
            ])
    }
    
    private func showLessText() {
        if let readMoreText = readMoreText, text.hasSuffix(readMoreText) { return }
        
        textContainer.maximumNumberOfLines = maximumNumberOfLines
        
        layoutManager.invalidateLayout(forCharacterRange: layoutManager.characterRangeThatFits(textContainer: textContainer), actualCharacterRange: nil)
        textContainer.size = CGSize(width: bounds.size.width, height: CGFloat.greatestFiniteMagnitude)
        
        if let text = attributedReadMoreText {
            let range = rangeToReplaceWithReadMoreText()
            guard range.location != NSNotFound else { return }
            
            textStorage.replaceCharacters(in: range, with: text)
        }
        
        invalidateIntrinsicContentSize()
    }
    
    private func rangeToReplaceWithReadMoreText() -> NSRange {
        let rangeThatFitsContainer = layoutManager.characterRangeThatFits(textContainer: textContainer)
        if NSMaxRange(rangeThatFitsContainer) == _originalTextLength {
            return NSMakeRange(NSNotFound, 0)
        }
        else {
            let lastCharacterIndex = characterIndexBeforeTrim(range: rangeThatFitsContainer)
            if lastCharacterIndex > 0 {
                return NSMakeRange(lastCharacterIndex, textStorage.length - lastCharacterIndex)
            }
            else {
                return NSMakeRange(NSNotFound, 0)
            }
        }
    }
    
    private func characterIndexBeforeTrim(range rangeThatFits: NSRange) -> Int {
        if let text = attributedReadMoreText {
            let readMoreBoundingRect = attributedReadMoreText(text: text, boundingRectThatFits: textContainer.size)
            let lastCharacterRect = layoutManager.boundingRectForCharacterRange(range: NSMakeRange(NSMaxRange(rangeThatFits)-1, 1), inTextContainer: textContainer)
            var point = lastCharacterRect.origin
            point.x = textContainer.size.width - ceil(readMoreBoundingRect.size.width)
            let glyphIndex = layoutManager.glyphIndex(for: point, in: textContainer, fractionOfDistanceThroughGlyph: nil)
            let characterIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
            return characterIndex - 1
        } else {
            return NSMaxRange(rangeThatFits) - readMoreText!.length
        }
    }
    
    private func attributedReadMoreText(text aText: NSAttributedString, boundingRectThatFits size: CGSize) -> CGRect {
        let textContainer = NSTextContainer(size: size)
        let textStorage = NSTextStorage(attributedString: aText)
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        let readMoreBoundingRect = layoutManager.boundingRectForCharacterRange(range: NSMakeRange(0, text.length), inTextContainer: textContainer)
        return readMoreBoundingRect
    }
    
    private func readMoreTextRange() -> NSRange {
        var readMoreTextRange = rangeToReplaceWithReadMoreText()
        if readMoreTextRange.location != NSNotFound {
            readMoreTextRange.length = readMoreText!.length + 1
        }
        return readMoreTextRange
    }
}

extension UITextView {
    
    func hitTest(pointInGliphRange aPoint: CGPoint, event: UIEvent?, test: (Int) -> UIView?) -> UIView? {
        guard let charIndex = charIndexForPointInGlyphRect(point: aPoint) else {
            return super.hitTest(aPoint, with: event)
        }
        guard textStorage.attribute(NSLinkAttributeName, at: charIndex, effectiveRange: nil) == nil else {
            return super.hitTest(aPoint, with: event)
        }
        return test(charIndex)
    }
    
    func pointIsInTextRange(point aPoint: CGPoint, range: NSRange, padding: UIEdgeInsets) -> Bool {
        var boundingRect = layoutManager.boundingRectForCharacterRange(range: range, inTextContainer: textContainer)
        boundingRect = boundingRect.offsetBy(dx: textContainerInset.left, dy: textContainerInset.top)
        boundingRect = boundingRect.insetBy(dx: -(padding.left + padding.right), dy: -(padding.top + padding.bottom))
        return boundingRect.contains(aPoint)
    }
    
    func charIndexForPointInGlyphRect(point aPoint: CGPoint) -> Int? {
        let point = CGPoint(x: aPoint.x, y: aPoint.y - textContainerInset.top)
        let glyphIndex = layoutManager.glyphIndex(for: point, in: textContainer)
        let glyphRect = layoutManager.boundingRect(forGlyphRange: NSMakeRange(glyphIndex, 1), in: textContainer)
        if glyphRect.contains(point) {
            return layoutManager.characterIndexForGlyph(at: glyphIndex)
        } else {
            return nil
        }
    }
}

extension String {
    var length: Int {
        return characters.count
    }
}

extension NSLayoutManager {
    
    func characterRangeThatFits(textContainer container: NSTextContainer) -> NSRange {
        var rangeThatFits = self.glyphRange(for: container)
        rangeThatFits = self.characterRange(forGlyphRange: rangeThatFits, actualGlyphRange: nil)
        return rangeThatFits
    }

    func boundingRectForCharacterRange(range aRange: NSRange, inTextContainer container: NSTextContainer) -> CGRect {
        let glyphRange = self.glyphRange(forCharacterRange: aRange, actualCharacterRange: nil)
        let boundingRect = self.boundingRect(forGlyphRange: glyphRange, in: container)
        return boundingRect
    }
    
}

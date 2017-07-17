//
//  TextViewCell.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/14/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class TextViewCell: UITableViewCell {
    fileprivate var onTextChanged: Style.TextChangeHandler?
    
    fileprivate var onLinesCountChanged: Style.LinesCountChangeHandler?
    
    fileprivate var contentHeight: CGFloat? = 0.0
    
    fileprivate var limit: Int?
    
    @IBOutlet fileprivate weak var textView: UITextView! {
        didSet {
            textView.delegate = self
            textView.textContainer.lineFragmentPadding = 0
            textView.textContainerInset = .zero
            textView.isScrollEnabled = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onTextChanged = nil
        onLinesCountChanged = nil
        contentHeight = nil
        textView.textContainerInset = .zero
        limit = nil
    }
    
    /// Has side-effect of modifying text view text. Only use in prototype cells for sizing
    func estimatedHeight(for text: String?, fixedWidth: CGFloat) -> CGFloat {
        textView.text = text
        let size = textView.sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        return max(44.0, size.height)
    }
    
    fileprivate func notifyLineCountsChangedIfNeeded(_ textView: UITextView) {
        let sizeToFit = CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude)
        let newContentHeight = textView.sizeThatFits(sizeToFit).height

        guard let previousContentHeight = contentHeight else {
            contentHeight = newContentHeight
            return
        }
        
        if previousContentHeight !==~ newContentHeight {
            contentHeight = newContentHeight
            onLinesCountChanged?(textView.text)
        }
    }
}

extension TextViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        onTextChanged?(textView.text)
        notifyLineCountsChangedIfNeeded(textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let limit = limit else {
            return true
        }
        return textView.text.characters.count + (text.characters.count - range.length) <= limit
    }
}

extension TextViewCell {
    struct Style {
        typealias TextChangeHandler = (String?) -> Void
        typealias LinesCountChangeHandler = (String?) -> Void
        
        let text: String?
        let font: UIFont
        let placeholder: String?
        let edgeInsets: UIEdgeInsets
        let charactersLimit: Int?
        let onTextChanged: TextChangeHandler?
        let onLinesCountChanged: LinesCountChangeHandler?
        
        init(text: String? = nil,
             font: UIFont = .systemFont(ofSize: UIFont.systemFontSize),
             placeholder: String? = nil,
             edgeInsets: UIEdgeInsets = .zero,
             charactersLimit: Int? = nil,
             onTextChanged: TextChangeHandler? = nil,
             onLinesCountChanged: LinesCountChangeHandler? = nil) {
            self.text = text
            self.font = font
            self.placeholder = placeholder
            self.edgeInsets = edgeInsets
            self.charactersLimit = charactersLimit
            self.onTextChanged = onTextChanged
            self.onLinesCountChanged = onLinesCountChanged
        }
    }
    
    func apply(style: Style) {
        textView.text = style.text
        textView.placeholder = style.placeholder
        textView.font = style.font
        limit = style.charactersLimit
        onTextChanged = style.onTextChanged
        onLinesCountChanged = style.onLinesCountChanged
        textView.textContainerInset = style.edgeInsets
    }
}

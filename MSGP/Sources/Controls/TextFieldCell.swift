//
//  TextFieldCell.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/14/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit
import SnapKit

class TextFieldCell: UITableViewCell {
    fileprivate var customContentView = UIView()
    
    fileprivate lazy var textField: UITextField = { [unowned self] in
        let textField = UITextField()
        textField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    fileprivate var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    fileprivate var onTextChanged: Style.TextChangeHandler?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    private func setup() {
        contentView.addSubview(customContentView)
        customContentView.addSubview(iconImageView)
        customContentView.addSubview(textField)
        setupLayout()
    }
    
    private func setupLayout() {
        customContentView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(customContentView)
            make.top.equalTo(customContentView)
            make.bottom.equalTo(customContentView)
            make.width.equalTo(0.0)
        }
        
        textField.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right)
            make.top.equalTo(customContentView)
            make.bottom.equalTo(customContentView)
            make.right.equalTo(customContentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        onTextChanged = nil
        iconImageView.snp.remakeConstraints { make in
            make.left.equalTo(customContentView)
            make.top.equalTo(customContentView)
            make.bottom.equalTo(customContentView)
            make.width.equalTo(0.0)
        }
    }
    
    func textFieldDidChange(textField: UITextField) {
        onTextChanged?(textField.text)
    }
}

extension TextFieldCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        onTextChanged?(textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension TextFieldCell {
    struct Style {
        typealias TextChangeHandler = (String?) -> Void
        
        let text: String?
        let placeholderText: String?
        let font: UIFont
        let onTextChanged: TextChangeHandler?
        let icon: UIImage? /// adjust edgeInsets to make sure text field doesn't overlap image
        let isSecureTextEntry: Bool
        let edgeInsets: UIEdgeInsets
        let clearButtonMode: UITextFieldViewMode
        let contentBackgroundColor: UIColor
        
        init(text: String?,
             placeholderText: String?,
             font: UIFont = .systemFont(ofSize: UIFont.systemFontSize),
             edgeInsets: UIEdgeInsets = .zero,
             isSecureTextEntry: Bool = false,
             clearButtonMode: UITextFieldViewMode = .whileEditing,
             contentBackgroundColor: UIColor = .clear,
             icon: UIImage? = nil,
             onTextChanged: TextChangeHandler? = nil) {
            self.text = text
            self.edgeInsets = edgeInsets
            self.placeholderText = placeholderText
            self.onTextChanged = onTextChanged
            self.clearButtonMode = clearButtonMode
            self.isSecureTextEntry = isSecureTextEntry
            self.contentBackgroundColor = contentBackgroundColor
            self.icon = icon
            self.font = font
        }
    }
    
    func apply(style: Style) {
        textField.text = style.text
        textField.font = style.font
        textField.placeholder = style.placeholderText
        textField.isSecureTextEntry = style.isSecureTextEntry
        textField.clearButtonMode = style.clearButtonMode
        onTextChanged = style.onTextChanged
        
        customContentView.backgroundColor = style.contentBackgroundColor
        
        customContentView.snp.remakeConstraints { make in
            make.edges.equalTo(style.edgeInsets)
        }
        
        if let icon = style.icon {
            iconImageView.image = icon
            iconImageView.snp.remakeConstraints { make in
                make.left.equalTo(customContentView)
                make.top.equalTo(customContentView)
                make.bottom.equalTo(customContentView)
                make.width.equalTo(customContentView.snp.height)
            }
        }
    }
}

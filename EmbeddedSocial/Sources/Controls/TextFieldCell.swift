//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
    
    @objc func textFieldDidChange(textField: UITextField) {
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
        let textColor: UIColor
        let placeholderText: NSAttributedString?
        let font: UIFont
        let onTextChanged: TextChangeHandler?
        let icon: UIImage? /// adjust edgeInsets to make sure text field doesn't overlap image
        let isSecureTextEntry: Bool
        let edgeInsets: UIEdgeInsets
        let clearButtonMode: UITextField.ViewMode
        let contentBackgroundColor: UIColor
        
        init(text: String?,
             textColor: UIColor,
             placeholderText: NSAttributedString?,
             font: UIFont = .systemFont(ofSize: UIFont.systemFontSize),
             edgeInsets: UIEdgeInsets = .zero,
             isSecureTextEntry: Bool = false,
             clearButtonMode: UITextField.ViewMode = .whileEditing,
             contentBackgroundColor: UIColor = .clear,
             icon: UIImage? = nil,
             onTextChanged: TextChangeHandler? = nil) {
            
            self.text = text
            self.textColor = textColor
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
        textField.textColor = style.textColor
        textField.font = style.font
        textField.attributedPlaceholder = style.placeholderText
        textField.isSecureTextEntry = style.isSecureTextEntry
        textField.clearButtonMode = style.clearButtonMode
        onTextChanged = style.onTextChanged
        
        customContentView.backgroundColor = style.contentBackgroundColor
        backgroundColor = style.contentBackgroundColor
        
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

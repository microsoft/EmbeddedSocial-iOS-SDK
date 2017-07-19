//
//  LoadingIndicatorView.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/18/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit
import SnapKit

class LoadingIndicatorView: UIView {
    
    lazy fileprivate var spinner: UIActivityIndicatorView = { [unowned self] in
        let spinner = UIActivityIndicatorView()
        self.addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        return spinner
    }()
    
    lazy fileprivate var errorLabel: UILabel = { [unowned self] in
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.backgroundColor = .green
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(self).offset(8)
            make.right.equalTo(self).offset(-8)
            make.centerY.equalTo(self)
        }
        return label
    }()
    
    var errorText: String? {
        get {
            return errorLabel.text
        }
        set {
            if isLoading {
                isLoading = false
            }
            errorLabel.text = newValue
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            spinner.isHidden = !isLoading
            errorLabel.isHidden = isLoading
            
            if isLoading {
                errorLabel.text = nil
                spinner.startAnimating()
            } else {
                spinner.stopAnimating()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        isUserInteractionEnabled = false
    }
}

extension LoadingIndicatorView {
    
    func apply(style: Style) {
        errorLabel.font = style.font
        errorLabel.textColor = style.textColor
        spinner.color = style.spinnerColor
        backgroundColor = style.backgroundColor
    }
    
    struct Style {
        let backgroundColor: UIColor
        let font: UIFont
        let textColor: UIColor
        let spinnerColor: UIColor
        
        static let standard = Style(backgroundColor: .clear,
                                    font: UIFont.systemFont(ofSize: 14),
                                    textColor: .gray,
                                    spinnerColor: .gray)
    }
}

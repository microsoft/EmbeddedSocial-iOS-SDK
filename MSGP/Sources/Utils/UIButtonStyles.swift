//
//  UIButtonStyles.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/26/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

extension UIButton {
    
    struct Style {
        let title: String?
        let backgroundColor: UIColor?
        let tintColor: UIColor
        let titleColor: UIColor
        let titleFont: UIFont
        let borderColor: UIColor?
        let borderWidth: CGFloat
        let cornerRadius: CGFloat
        
        init(title: String?, backgroundColor: UIColor?, tintColor: UIColor, titleColor: UIColor,
             titleFont: UIFont, borderColor: UIColor?, borderWidth: CGFloat, cornerRadius: CGFloat) {
            self.title = title
            self.backgroundColor = backgroundColor
            self.tintColor = tintColor
            self.titleColor = titleColor
            self.titleFont = titleFont
            self.borderColor = borderColor
            self.borderWidth = borderWidth
            self.cornerRadius = cornerRadius
        }
    }
}

extension UIButton.Style {
    
    static var follow: UIButton.Style {
        return UIButton.Style(title: "FOLLOW",
                              backgroundColor: .clear,
                              tintColor: Palette.green,
                              titleColor: Palette.green,
                              titleFont: Fonts.small,
                              borderColor: Palette.green,
                              borderWidth: 1.0,
                              cornerRadius: 8.0)
    }
    
    static var pending: UIButton.Style {
        return UIButton.Style(title: "PENDING",
                              backgroundColor: .clear,
                              tintColor: Palette.lightGrey,
                              titleColor: Palette.lightGrey,
                              titleFont: Fonts.small,
                              borderColor: Palette.lightGrey,
                              borderWidth: 1.0,
                              cornerRadius: 8.0)
    }
    
    static var following: UIButton.Style {
        return UIButton.Style(title: "FOLLOWING",
                              backgroundColor: Palette.green,
                              tintColor: Palette.green,
                              titleColor: Palette.white,
                              titleFont: Fonts.small,
                              borderColor: nil,
                              borderWidth: 0.0,
                              cornerRadius: 8.0)
    }
    
    static var blocked: UIButton.Style {
        return UIButton.Style(title: "BLOCKED",
                              backgroundColor: .clear,
                              tintColor: Palette.lightGrey,
                              titleColor: Palette.lightGrey,
                              titleFont: Fonts.small,
                              borderColor: Palette.lightGrey,
                              borderWidth: 1.0,
                              cornerRadius: 8.0)
    }
}

extension UIButton {
    
    func apply(style: Style) {
        backgroundColor = style.backgroundColor
        tintColor = style.tintColor
        titleLabel?.font = style.titleFont
        
        setTitle(style.title, for: .normal)
        setTitleColor(style.titleColor, for: .normal)
        
        layer.borderColor = style.borderColor?.cgColor
        layer.borderWidth = style.borderWidth
        layer.cornerRadius = style.cornerRadius
        
        sizeToFit()
    }
}

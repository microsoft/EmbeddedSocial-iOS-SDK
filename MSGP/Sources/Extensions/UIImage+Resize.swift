//
//  UIImage+Resize.swift
//  GymKeeper
//
//  Created by Vadim Bulavin on 5/19/17.
//  Copyright © 2017 V8tr. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func scaledToFit(toSize newSize: CGSize) -> UIImage {
        if size.width < newSize.width && size.height < newSize.height {
            return (copy() as? UIImage) ?? UIImage()
        }
        
        let widthScale = newSize.width / size.width
        let heightScale = newSize.height / size.height
        
        let scaleFactor = widthScale < heightScale ? widthScale : heightScale
        let scaledSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        
        return scaled(toSize: scaledSize,
                      in: CGRect(x: 0.0, y: 0.0, width: scaledSize.width, height: scaledSize.height))
    }
    
    func scaled(toSize newSize: CGSize, in rect: CGRect) -> UIImage {
        if UIScreen.main.scale == 2.0 {
            UIGraphicsBeginImageContextWithOptions(newSize, !hasAlphaChannel, 2.0)
        } else {
            UIGraphicsBeginImageContext(newSize)
        }
        
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? UIImage()
    }
    
    var hasAlphaChannel: Bool {
        guard let alpha = cgImage?.alphaInfo else {
            return false
        }
        return alpha == CGImageAlphaInfo.first ||
            alpha == CGImageAlphaInfo.last ||
            alpha == CGImageAlphaInfo.premultipliedFirst ||
            alpha == CGImageAlphaInfo.premultipliedLast
    }
}

//
//  CellModel.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/14/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

enum CreateAccountItem {
    case uploadPhoto(Photo?)
    case firstName(TextFieldCell.Style)
    case lastName(TextFieldCell.Style)
    case bio(TextViewCell.Style)
}

extension CreateAccountItem: CellModel {
    var reuseID: String {
        switch self {
        case .uploadPhoto:
            return UploadPhotoCell.reuseID
        case .firstName, .lastName:
            return TextFieldCell.reuseID
        case .bio:
            return TextViewCell.reuseID
        }
    }
    
    var cellClass: UITableViewCell.Type {
        switch self {
        case .uploadPhoto:
            return UploadPhotoCell.self
        case .firstName, .lastName:
            return TextFieldCell.self
        case .bio:
            return TextViewCell.self
        }
    }
}

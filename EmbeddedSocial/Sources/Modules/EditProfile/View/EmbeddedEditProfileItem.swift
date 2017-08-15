//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

enum EmbeddedEditProfileItem {
    case uploadPhoto(Photo?)
    case firstName(TextFieldCell.Style)
    case lastName(TextFieldCell.Style)
    case bio(TextViewCell.Style)
}

enum EmbeddedEditProfileGroupHeader {
    case accountInformation(GroupHeaderTableCell.Style, String?)
}

extension EmbeddedEditProfileItem: CellModel {
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

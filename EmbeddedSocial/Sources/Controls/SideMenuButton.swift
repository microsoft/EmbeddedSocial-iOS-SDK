//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class SideMenuButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = (isSelected) ? UIColor.white.withAlphaComponent(0.4) : Palette.darkGrey
        }
    }
    
}


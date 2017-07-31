//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class ButtonDecorator: UIButton {
    
    let decoratedButton: UIButton
    
    required init(decoratedButton: UIButton) {
        self.decoratedButton = decoratedButton
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol LoginViewOutput {
    func viewIsReady()
        
    func onFacebookSignInTapped()
    
    func onGoogleSignInTapped()
    
    func onTwitterSignInTapped()
    
    func onMicrosoftSignInTapped()
    
    func onCancel()
}

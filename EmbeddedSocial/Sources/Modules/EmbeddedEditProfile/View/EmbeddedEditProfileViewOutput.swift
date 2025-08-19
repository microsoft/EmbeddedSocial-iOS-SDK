//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol EmbeddedEditProfileViewOutput: class {    
    func onFirstNameChanged(_ text: String?)
    
    func onLastNameChanged(_ text: String?)
    
    func onBioChanged(_ text: String?)
    
    func onSelectPhoto()
}

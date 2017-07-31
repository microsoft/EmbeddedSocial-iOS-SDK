//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct CreateAccountCellModelsBuilder {
    typealias Section = CreateAccountDataDisplayManager.Section
    typealias TextChangedHandler = (String?) -> Void
    
    var onFirstNameChanged: TextChangedHandler?
    var onLastNameChanged: TextChangedHandler?
    var onBioChanged: TextChangedHandler?
    var onBioLinesCountChanged: (() -> Void)?
    
    func makeSections(user: SocialUser) -> [Section] {
        return [makeSection1(user: user), makeSection2(user: user)]
    }
    
    private func makeSection1(user: SocialUser) -> Section {
        return Section(model: nil, items: [
            .uploadPhoto(user.photo)
            ])
    }
    
    private func makeSection2(user: SocialUser) -> Section {
        let bioVerticalOffset: CGFloat = 12.0
        let edgeInsets = UIEdgeInsets(top: bioVerticalOffset,
                                      left: Constants.CreateAccount.contentPadding,
                                      bottom: bioVerticalOffset,
                                      right: Constants.CreateAccount.contentPadding)
        
        let firstNameStyle = TextFieldCell.Style(
            text: user.firstName,
            placeholderText: "First name",
            font: Fonts.regular,
            edgeInsets: edgeInsets,
            onTextChanged: onFirstNameChanged
        )
        
        let lastNameStyle = TextFieldCell.Style(
            text: user.lastName,
            placeholderText: "Last name",
            font: Fonts.regular,
            edgeInsets: edgeInsets,
            onTextChanged: onLastNameChanged
        )
        
        let bioStyle = TextViewCell.Style(
            text: user.bio,
            font: Fonts.regular,
            placeholder: "Bio",
            edgeInsets: edgeInsets,
            charactersLimit: Constants.CreateAccount.maxBioLength,
            onTextChanged: onBioChanged,
            onLinesCountChanged: { _ in self.onBioLinesCountChanged?() }
        )
        
        let headerModel = CreateAccountGroupHeader.accountInformation(.createAccount, "ACCOUNT INFORMATION")
        return Section(model: headerModel, items: [
            .firstName(firstNameStyle),
            .lastName(lastNameStyle),
            .bio(bioStyle)
            ])
    }
}

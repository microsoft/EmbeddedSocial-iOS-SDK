//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct EmbeddedEditProfileCellsBuilder {
    typealias Section = EmbeddedEditProfileDataDisplayManager.Section
    typealias TextChangedHandler = (String?) -> Void
    
    var onFirstNameChanged: TextChangedHandler?
    var onLastNameChanged: TextChangedHandler?
    var onBioChanged: TextChangedHandler?
    var onBioLinesCountChanged: (() -> Void)?
    
    func makeSections(user: User) -> [Section] {
        return [makeSection1(user: user), makeSection2(user: user)]
    }
    
    private func makeSection1(user: User) -> Section {
        return Section(model: nil, items: [
            .uploadPhoto(user.photo)
        ])
    }
    
    private func makeSection2(user: User) -> Section {
        let bioVerticalOffset: CGFloat = 12.0
        let edgeInsets = UIEdgeInsets(top: bioVerticalOffset,
                                      left: Constants.EditProfile.contentPadding,
                                      bottom: bioVerticalOffset,
                                      right: Constants.EditProfile.contentPadding)
        
        let firstNameStyle = TextFieldCell.Style(
            text: user.firstName,
            placeholderText: L10n.EditProfile.Placeholder.firstName,
            font: AppFonts.regular,
            edgeInsets: edgeInsets,
            onTextChanged: onFirstNameChanged
        )
        
        let lastNameStyle = TextFieldCell.Style(
            text: user.lastName,
            placeholderText: L10n.EditProfile.Placeholder.lastName,
            font: AppFonts.regular,
            edgeInsets: edgeInsets,
            onTextChanged: onLastNameChanged
        )
        
        let bioStyle = TextViewCell.Style(
            text: user.bio,
            font: AppFonts.regular,
            placeholder: L10n.EditProfile.Placeholder.bio,
            edgeInsets: edgeInsets,
            charactersLimit: Constants.EditProfile.maxBioLength,
            onTextChanged: onBioChanged,
            onLinesCountChanged: { _ in self.onBioLinesCountChanged?() }
        )
        
        let headerModel = EmbeddedEditProfileGroupHeader.accountInformation(
            .editProfile, L10n.EditProfile.Label.accountInformation.uppercased())
        return Section(model: headerModel, items: [
            .firstName(firstNameStyle),
            .lastName(lastNameStyle),
            .bio(bioStyle)
        ])
    }
}

//
//  CreateAccountCellModelsBuilder.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/14/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

struct CreateAccountCellModelsBuilder {
    typealias Section = CreateAccountDataDisplayManager.Section
    typealias TextChangedHandler = (String?) -> Void
    
    var onFirstNameChanged: TextChangedHandler?
    var onLastNameChanged: TextChangedHandler?
    var onBioChanged: TextChangedHandler?
    var onBioLinesCountChanged: (() -> Void)?
    
    func makeSections(user: SocialUser, tableView: UITableView) -> [Section] {
        let section1 = Section(model: nil, items: [
            .uploadPhoto(user.photo)
            ])
        
        let bioVerticalOffset: CGFloat = 8.0
        let edgeInsets = UIEdgeInsets(top: bioVerticalOffset,
                                      left: Constants.createAccountContentPadding,
                                      bottom: bioVerticalOffset,
                                      right: Constants.createAccountContentPadding)
        
        let firstNameStyle = TextFieldCell.Style(
            text: user.firstName,
            placeholderText: "First name",
            edgeInsets: edgeInsets,
            onTextChanged: onFirstNameChanged
        )
        
        let lastNameStyle = TextFieldCell.Style(
            text: user.lastName,
            placeholderText: "Last name",
            edgeInsets: edgeInsets,
            onTextChanged: onLastNameChanged
        )
        
        let bioStyle = TextViewCell.Style(
            text: nil,
            placeholder: "Bio",
            edgeInsets: edgeInsets,
            onTextChanged: onBioChanged,
            onLinesCountChanged: { _ in self.onBioLinesCountChanged?() }
        )
        
        let section2 = Section(model: nil, items: [
            .firstName(firstNameStyle),
            .lastName(lastNameStyle),
            .bio(bioStyle)
            ])
        
        for item in section1.items + section2.items {
            tableView.register(cellClass: item.cellClass)
        }
        
        return [section1, section2]
    }
}

//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol Reusable {
    static var reuseID: String { get }
}

extension Reusable {
    static var reuseID: String {
        return String(describing: self)
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseID, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseID)")
        }
        
        return cell
    }
}

extension UIView: Reusable { }

extension Reusable where Self: UIView {
    /// Don't set a nib's owner. Set view's class to the one being loaded.
    static func fromNib() -> Self {
        return Bundle(for: self).loadNibNamed(Self.reuseID, owner: nil, options: nil)![0] as! Self
    }
    
    /// Set a view class as it's nib owner. Don't set any class to the view itself.
    /// Your view will act as a content view.
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: Self.reuseID, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        return view
    }
}

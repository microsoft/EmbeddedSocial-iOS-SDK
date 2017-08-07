//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class UserProfileScrollCoordinator {
    let containerScrollView: UIScrollView
    let mainView: UIView
    let headerHeight: CGFloat
    let containerInset: CGFloat
    let feedView: CollectionView
    
    init(containerScrollView: UIScrollView,
         mainView: UIView,
         headerHeight: CGFloat,
         containerInset: CGFloat,
         feedView: CollectionView) {
        self.containerScrollView = containerScrollView
        self.mainView = mainView
        self.headerHeight = headerHeight
        self.containerInset = containerInset
        self.feedView = feedView
    }

    private var lastTouchLocation = CGPoint.zero
    
    func didScrollContainer() {
        let isContainerScrolledAtMax = containerScrollView.contentOffset.y > headerHeight + containerInset * 2
        if isContainerScrolledAtMax {
            feedView.isTrackingTouches = true
        }
    }
    
    func didScrollFeed(_ view: UIScrollView) {        
        let touchLocation = feedView.panGestureRecognizer.translation(in: mainView)
        
        guard feedView.panGestureRecognizer.state == .changed else {
            lastTouchLocation = touchLocation
            return
        }
        
        let isContainerScrolledAtMax = containerScrollView.contentOffset.y > headerHeight + containerInset * 2
        let distance = lastTouchLocation.y - touchLocation.y
        let isScrollingUp = distance > 0
        
        print("isUp \(isScrollingUp) distance \(distance) container \(containerScrollView.contentOffset) lastOffset \(lastTouchLocation) containerOffset \(containerScrollView.contentOffset) feedOffset \(feedView.contentOffset)")
        
        if isScrollingUp {
            if !isContainerScrolledAtMax {
                containerScrollView.contentOffset = CGPoint(x: containerScrollView.contentOffset.x,
                                                            y: containerScrollView.contentOffset.y + feedView.contentOffset.y)
                feedView.contentOffset = .zero
                feedView.isTrackingTouches = false
            } else {
                feedView.isTrackingTouches = true
            }
        } else {
            if feedView.contentOffset.y <= 0 && containerScrollView.contentOffset.y > 0 {
                containerScrollView.contentOffset = CGPoint(x: containerScrollView.contentOffset.x,
                                                            y: containerScrollView.contentOffset.y + feedView.contentOffset.y)
                feedView.contentOffset = .zero
                feedView.isTrackingTouches = false
            } else {
                feedView.isTrackingTouches = true
            }
        }
        
        lastTouchLocation = touchLocation
    }
    
    
}

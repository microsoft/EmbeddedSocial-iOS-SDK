//
//  FeedGalleryViewController.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class FeedGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    @IBOutlet weak var toggleGalleryListButton: UIBarButtonItem!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    var galleryImages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        if self.revealViewController() != nil {
            let menuButton = UIButton()
            menuButton.frame = CGRectMake(0, 0, 22, 22)
            menuButton.setBackgroundImage(UIImage(named: "icon_hamburger.png"), forState: UIControlState.Normal)
            menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
            
            hamburgerButton.customView = menuButton
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        let toggleViewButton = UIButton()
        toggleViewButton.frame = CGRectMake(0, 0, 20, 20)
        toggleViewButton.setBackgroundImage(UIImage(named: "icon_list.png"), forState: UIControlState.Normal)
        //Do something to switch between list and gallery view and change the background image
        
        toggleGalleryListButton.customView = toggleViewButton
        
        galleryImages = [
            "galleryTest1.png",
            "galleryTest2.png",
            "galleryTest3.png",
            "galleryTest4.png",
            "galleryTest5.png",
            "galleryTest6.png",
            "galleryTest7.png",
            "galleryTest8.png",
            "galleryTest9.png",
            "galleryTest10.png",
            "galleryTest11.png",
            "galleryTest12.png",
            "galleryTest13.png",
            "galleryTest14.png"
        ]

    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = galleryCollectionView.dequeueReusableCellWithReuseIdentifier("FeedGalleryCollectionViewCell", forIndexPath: indexPath) as! FeedGalleryCollectionViewCell
        let image = UIImage(named: galleryImages[indexPath.row])
        cell.feedGalleryCellImage.image = image
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//
//  HomeHomeViewController.swift
//  MSGP-Framework
//
//  Created by igor.popov on 24/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, HomeViewInput {

    var output: HomeViewOutput!
    
    @IBOutlet weak var collectionView: UICollectionView?

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        self.collectionView?.register(TopicCell.nib, forCellWithReuseIdentifier: TopicCell.reuseID)
        
        if let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: 50, height: 50)
        }
    }
    
    // MARK: HomeViewInput
    func setupInitialState() {
        
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return output.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellData = output.itemModel(for: indexPath)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCell.reuseID, for: indexPath) as? TopicCell else {
            fatalError("Wrong cell")
        }
        
        cell.configure(with: cellData)
        
        return cell
    }

}

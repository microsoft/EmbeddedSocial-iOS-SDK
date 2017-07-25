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
    
    lazy var gridLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        return layout
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        self.collectionView?.register(TopicCell.nib, forCellWithReuseIdentifier: TopicCell.reuseID)
    }
    
    // MARK: HomeViewInput
    func setupInitialState() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.collectionView?.collectionViewLayout.invalidateLayout()
            self.collectionView?.setCollectionViewLayout(self.gridLayout, animated: true)
        }
    }
    
    lazy var sizingCell: TopicCell = { [unowned self] in
        let cell = TopicCell.nib.instantiate(withOwner: nil, options: nil).last as! TopicCell
        let width = self.collectionView!.bounds.width
        let height = cell.frame.height
        cell.frame = CGRect(x: 0, y: 0, width: width, height: height)
        return cell
    }()
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionViewLayout == gridLayout {
            return gridLayout.itemSize
        }
        
        let cellData = output.itemModel(for: indexPath)
        sizingCell.configure(with: cellData)
        
        sizingCell.needsUpdateConstraints()
        sizingCell.updateConstraints()
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()

        return sizingCell.container.bounds.size
    }

}

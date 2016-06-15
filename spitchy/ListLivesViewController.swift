//
//  ListLivesViewController.swift
//  Spitchy
//
//  Created by Kévin Rignault on 07/06/2016.
//  Copyright © 2016 rplay. All rights reserved.
//

import Foundation
import UIKit

class ListLivesViewController: UIViewController {

    var thisTopic:String!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var mainBackground: UIImageView!
    
    var lives = [ListLiveModel]()
    
    override func viewDidLoad() {
        design()
        collectionView.contentInset.top = 40
    }
    
    func design(){
        navBar.topItem?.title = thisTopic
    }
    
    func bufferToImage(){
        
    }
    
}

extension ListLivesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : ListLiveCell = collectionView.dequeueReusableCellWithReuseIdentifier("liveCell", forIndexPath: indexPath) as! ListLiveCell
        
        //cell.username.text = lives[indexPath.row].username
        //cell.nbViewers.text = String(lives[indexPath.row].nbUsers)
        //cell.backgroundColor = UIColor.redColor()
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var closestCell : UICollectionViewCell = collectionView.visibleCells()[0];
        for cell in collectionView!.visibleCells() as [UICollectionViewCell] {
            let closestCellDelta = abs(closestCell.center.y - collectionView.bounds.size.height/2.0 - collectionView.contentOffset.y)
            let cellDelta = abs(cell.center.y - collectionView.bounds.size.height/2.0 - collectionView.contentOffset.y)
            if (cellDelta < closestCellDelta){
                closestCell = cell
            }
        }
        let indexPath = collectionView.indexPathForCell(closestCell)
        
        if(indexPath!.row > 0){
            collectionView.contentInset.top = 0
        }
        else {
            collectionView.contentInset.top = 40
        }
        
        collectionView.scrollToItemAtIndexPath(indexPath!, atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: true)
    }
    
}

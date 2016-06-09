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
    
    override func viewDidLoad() {
        design()
        collectionView.contentInset.top = collectionView.frame.height / 2 + 10
    }
    
    func design(){
        navBar.topItem?.title = thisTopic
    }
    
}

extension ListLivesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : ListLiveCell = collectionView.dequeueReusableCellWithReuseIdentifier("liveCell", forIndexPath: indexPath) as! ListLiveCell
        
        cell.backgroundColor = UIColor.redColor()
        
        return cell
    }
    
}

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
    var socket: SocketIOClient?
    
    var fakeData = [
        ["bytes_per_row" : 796, "width" : 640, "height" : 480, "pixel_format" : 1111970369 ],
        ["bytes_per_row" : 796, "width" : 640, "height" : 480, "pixel_format" : 1111970369 ]
    ]
    
    override func viewDidLoad() {
        
        initFakeData()
        socket = SocketIOClient(socketURL: "vps224869.ovh.net:3005")
        
        socket?.connect()
        
        design()
        collectionView.contentInset.top = 40
        
    }
    
    func design(){
        navBar.topItem?.title = thisTopic
        self.mainBackground.image = lives[0].image
    }
    
    func initFakeData(){
        for data in fakeData {
            lives.append(ListLiveModel(bytesPerRow: data["bytes_per_row"]!, videoWidth: data["width"]!, videoHeight: data["height"]!, pixelFormat: data["height"]!))
        }
    }
    
    
    func livePreview(indexPath: NSIndexPath, cell: ListLiveCell) {
                
        socket?.on("buffer_to_device") { data, ack in
            
            if let buffer = data[0] as? NSData {
                let imageUncompressed = buffer.uncompressedDataUsingCompression(Compression.LZMA)
                cell.image.image = UIImage(data: imageUncompressed!)
            }
            
        }
    }
    
}

extension ListLivesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fakeData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : ListLiveCell = collectionView.dequeueReusableCellWithReuseIdentifier("liveCell", forIndexPath: indexPath) as! ListLiveCell
        
        cell.username.text = "Jean mi"
        cell.nbViewers.text = "4444"
        cell.image.image = lives[indexPath.row].image
        
        
        
        //cell.username.text = lives[indexPath.row].username
        //cell.nbViewers.text = String(lives[indexPath.row].nbUsers)
        //cell.backgroundColor = UIColor.redColor()
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var closestCell : ListLiveCell = collectionView.visibleCells()[0] as! ListLiveCell
        for cell in collectionView!.visibleCells() as! [ListLiveCell] {
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
        
        livePreview(indexPath!, cell: closestCell)
    }
    
}

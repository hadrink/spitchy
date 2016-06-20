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
        ["username" : "Jean-mi", "nb_users" : 640, "preview_image" : "topic-economy", "live_id" : "buffer_to_device" ],
        ["username" : "Paul", "nb_users" : 400, "preview_image" : "topic-politique", "live_id" : "buffer_to_device" ],
        ["username" : "Bertrand", "nb_users" : 300, "preview_image" : "topic-sport", "live_id" : "buffer_to_device" ]
    ]
    
    override func viewDidLoad() {
        
        
        initFakeData()
        socket = SocketIOClient(socketURL: "vps224869.ovh.net:3005")
        
        socket?.connect()
        
        design()
        collectionView.contentInset.top = 40
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print(thisTopic)
        navBar.topItem?.title = thisTopic
    }
    
    func design(){
        collectionView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.mainBackground.image = lives[0].image
        blurImage(mainBackground)
    }
    
    func blurImage(image: UIImageView) {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = image.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        image.addSubview(blurEffectView)
    }
    
    func changeBackgroundWithFade(imageView: UIImageView, newImage: UIImage, animationDuration: NSTimeInterval = 2) {
        
        let transition = CATransition()
        imageView.layer.addAnimation(transition, forKey: kCATransition)
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = animationDuration
        print(transition.startProgress)
        print(transition.endProgress)

        
        imageView.image = newImage
        
    }
    
    func initFakeData(){
        for data in fakeData {
            lives.append(
                ListLiveModel(
                    username  : data["username"] as! String,
                    nbUsers   : data["nb_users"] as! Int,
                    liveID    : data["live_id"] as! String,
                    imageName : data["preview_image"] as! String
                )
            )
        }
    }
    
    
    func livePreview(indexPath: NSIndexPath, cell: ListLiveCell) {
        
        guard let liveToPreview = lives[indexPath.row].liveID else {
            print("Lives at \(indexPath.row) doesn't contain a liveID ")
            return
        }
            
        socket?.on(liveToPreview) { data, ack in
            if let buffer = data[0] as? NSData {
                let imageUncompressed = buffer.uncompressedDataUsingCompression(Compression.LZMA)
                cell.image.image = UIImage(data: imageUncompressed!)
            }
        }
    }
        
    @IBAction func goBackAction(sender: AnyObject) {
        bridgeController.goToPreviousVC()
    }

}
        

extension ListLivesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fakeData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : ListLiveCell = collectionView.dequeueReusableCellWithReuseIdentifier("liveCell", forIndexPath: indexPath) as! ListLiveCell
        
        cell.designCell()
        cell.username.text  = lives[indexPath.row].username
        cell.nbViewers.text = lives[indexPath.row].nbUsers! + " viewers"
        cell.image.image    = lives[indexPath.row].image
        
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
        
        guard let indexPath = collectionView.indexPathForCell(closestCell) else {
            print("No indexPath for closetCell.")
            return
        }
        
        if(indexPath.row > 0){
            collectionView.contentInset.top = 0
        }
        else {
            collectionView.contentInset.top = 40
        }
        
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: true)
        
        guard let newBackgroundImage = lives[indexPath.row].image else {
            print("No background image in lives at indexPath.")
            return
        }
        
        dispatch_async(dispatch_get_main_queue(),{
            
            self.changeBackgroundWithFade(self.mainBackground, newImage: newBackgroundImage)
    
        })
        
        livePreview(indexPath, cell: closestCell)
    }
    
    
}

//
//  BridgeController.swift
//  Spitchy
//
//  Created by Rplay on 31/05/16.
//  Copyright © 2016 rplay. All rights reserved.
//

import UIKit

//-- Const to load BridgeController
let bridgeController = BridgeController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)

class BridgeController: UIPageViewController, UIScrollViewDelegate {
    
    //-- Declare VC
    let CameraVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CameraView")
    let ProfileVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProfileView")
    let TopicVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TopicView")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //-- Change global background color
        view.backgroundColor = UIColor.whiteColor()
        
        //-- Delegate method to use UIPageViewControllerDataSource
        dataSource = self
        
        //-- Display the first view to show
        setViewControllers([CameraVC], direction: .Forward, animated: true, completion: nil)
    }
    
    //-- Switch view when user click action
    func goToNextVC() {
        
        let nextVC = pageViewController(self, viewControllerAfterViewController: viewControllers![0] )!
        setViewControllers([nextVC], direction: .Forward, animated: true, completion: nil)
    }
    
    func goToPreviousVC() {
        let previousVC = pageViewController(self, viewControllerBeforeViewController: viewControllers![0] )!
        setViewControllers([previousVC], direction: .Reverse, animated: true, completion: nil)
        
    }
    
}

//-- UIPageViewControllerDataSource
extension BridgeController: UIPageViewControllerDataSource {
    
    //-- Load views after and before the current view
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        switch viewController {
        case CameraVC:
            return ProfileVC
        case ProfileVC:
            return nil
        case TopicVC:
            return CameraVC
        default:
            return nil
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        switch viewController {
        case CameraVC:
            return TopicVC
        case ProfileVC:
            return CameraVC
        default:
            return nil
        }
    }
}

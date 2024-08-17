//
//  ViewController.swift
//  Kinker
//
//  Created by clove on 7/13/20.
//  Copyright © 2020 personal.Justin. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON
import Reachability
import CoreTelephony.CTCellularData
    
extension MVMViewController {
    public class func loginTransition() {
        if  let root = UIApplication.shared.keyWindow?.rootViewController as? MVRootViewController, let vc = root.mainViewController as? MVMViewController  {
            vc.loginTransition()
        }
    }
    
    public class func logoutTransition() {
        if  let root = UIApplication.shared.keyWindow?.rootViewController as? MVRootViewController, let vc = root.mainViewController as? MVMViewController  {
            vc.logoutTransition()
        }
    }
}

class MVMViewController: LXBaseViewController {
    
        var _guideNavigationController : LXBaseNavigationController?
        var _homeViewController : UIViewController?
        
        var guideNavigationController: LXBaseNavigationController {
            get {
                if _guideNavigationController != nil {
                    return _guideNavigationController!
                } else {
                    let vc = HVFirstInVC()
                    _guideNavigationController = LXBaseNavigationController(rootViewController:vc)
                    self.addChild(_guideNavigationController!)
                    return _guideNavigationController!
                }
            }
        }
        
        var homeViewController: UIViewController {
            get {
                if _homeViewController != nil {
                    return _homeViewController!
                } else {
                    let vc = HVHomeViewController()
                    _homeViewController = vc
                    self.addChild(_homeViewController!)
                    return _homeViewController!
                }
            }
        }
    
        public func logoutTransition() {
            guard let vc = _homeViewController else { return }
            
            UIView.transition(from: vc.view,
                              to: self.guideNavigationController.view,
                              duration: 0.5,
                              options: .transitionCrossDissolve) { _ in
                                self.removeHomeVC()
            }
        }
        
        public func loginTransition() {
            UIView.transition(from: self.guideNavigationController.view,
                              to: self.homeViewController.view,
                              duration: 0.5,
                              options: .transitionCrossDissolve) { _ in
                                self.removeGuideNV()
            }
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .backgroundColor
            
            self.view.addSubview(self.homeViewController.view)
                        
            if HVConfModel.isShownAgreement == false ||
                (User.isVip() == false &&  HVConfModel.isShownPurchaseGuideToday == false) {
                self.view.addSubview(self.guideNavigationController.view)
            } else {
                self.view.addSubview(self.homeViewController.view)
            }
        }
        
        func removeHomeVC() {
            _homeViewController?.removeFromParent()
            _homeViewController?.view.removeFromSuperview()
            _homeViewController = nil
        }
        
        func removeGuideNV() {
            _guideNavigationController?.removeFromParent()
            _guideNavigationController?.view.removeFromSuperview()
            _guideNavigationController = nil
        }
}


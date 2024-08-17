//
//  MVGuideVC.swift
//  GOGOVPN
//
//  Created by Justin on 2022/6/22.
//

import Foundation
import HandyJSON


class MVGuideVC: LXBaseViewController {

    deinit {
        debugPrint("\(NSStringFromClass(type(of: self))) \(#function)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if MVConfigModel.isShownAgreement == false {
//            showAgreement()
//        } else {
            showPurchaseGuide()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func showAgreement() {
//        let vc = GGAgreementViewController()
//        self.view.addSubview(vc.view)
//        self.addChild(vc)
    }
    
    func showPurchaseGuide() {
        let vc = MVPremiumViewController()
        vc.closeButton.isHidden = false
        self.navigationController?.pushViewController(vc, animated: false)
        vc.complete = { [unowned vc] (result, errMsg) in
            MVConfigModel.isShownPurchaseGuideToday = true
            if (result == true) {
                MVMViewController.loginTransition()
            }
        }
    }
}



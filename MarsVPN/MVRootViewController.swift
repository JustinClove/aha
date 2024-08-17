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

let SAFE_AREA_TOP = UIApplication.shared.firstWindowScene?.statusBarManager?.statusBarFrame.height ?? 0

class MVRootViewController: LXBaseViewController {
    var _isShownAgreement = MVConfigModel.isShownAgreement
    
    var _mainViewController : UIViewController?
    var _launchViewController : UIViewController?
    var mainViewController: UIViewController {
        get {
            if _mainViewController != nil {
                return _mainViewController!
            } else {
                let vc = MVMViewController()
                _mainViewController = vc
                self.addChild(_mainViewController!)
                return _mainViewController!
            }
        }
    }
    
    var launchViewController: UIViewController {
        get {
            if _launchViewController != nil {
                return _launchViewController!
            } else {
                let sb = UIStoryboard(name: "LaunchScreen", bundle: Bundle.main)
                let vc = sb.instantiateViewController(identifier: "MVLaunchScreen")
                _launchViewController = vc
                self.addChild(_launchViewController!)
                return _launchViewController!
            }
        }
    }
    
    public func mainTransition() {
        guard let vc = _launchViewController else { return }
        
        UIView.transition(from: vc.view,
                          to: self.mainViewController.view,
                          duration: 0.25,
                          options: .transitionCrossDissolve) { _ in
                            self.removeLaunchVC()
        }
    }
    
    func hideLaunchScreenWhenAdsDidShow() {
        let vc = self.mainViewController
        self.view.addSubview(vc.view)
        self.addChild(vc)
        self.removeLaunchVC()
    }
    
    public func lauchTransition() {
        showLauchScreen()
        self.removeMainVC()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
//        AppOpenAdManager.shared.appOpenAdManagerDelegate = self
//        AppOpenAdManager.shared.loadAd()
        AdmobAdsManager.shared.interstitialAd0?.delegate = self
        AdmobAdsManager.shared.interstitialAd0?.loadInterstitial()

        if MVConfigModel.isShownAgreement == false || (MVConfigModel.isVIP() == false &&  MVConfigModel.isShownPurchaseGuideToday == false) {
            // 自动获取必要数据
//            HVSingleManager.autologinAndProduct1 {
//                self.hideAtLauchIfNeeded()
//            }
            MVIAPManager.fetchProduct1 { [unowned self] reuslt in
                self.hideAtLauchIfNeeded()
//                if !MVConfigModel.isVIP() && self._isShownAgreement {
//                    AdmobAdsManager.showInterstitial0(force:true, in: self) { _,_,_ in
//                        debugPrint("AdmobAdsManager.showInterstitial0")
//                    }
//                } else {
//                    mainTransition()
//                }
            }

        } else {
            // 自动获取必要数据
//            HVSingleManager.autologinAndLocations {
//                //为 VPNHelper.shared 获取数据延时
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    self.hideAtLauchIfNeeded()
//                }
//            }
            MVIAPManager.fetchProduct1 { reuslt in
                //为 VPNHelper.shared 获取数据延时
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
                    self.hideAtLauchIfNeeded()
//                    if !MVConfigModel.isVIP() && self._isShownAgreement {
//                        AdmobAdsManager.showInterstitial0(force:true, in: self) { _,_,_ in
//                            debugPrint("AdmobAdsManager.showInterstitial0")
//                        }
//                    } else {
//                        self.mainTransition()
//                    }
                }
            }
        }
        
        showLauchScreen()
        
        // 获取数据超时跳过
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.hideAtLauchIfNeeded(isTimeout: true)
        }

        registerReachability()
        
        //第一次启动结束
        MVConfigModel.setIsShownAgreement()
    }
    
    func removeLaunchVC() {
        _launchViewController?.removeFromParent()
        _launchViewController?.view.removeFromSuperview()
    }
    
    func removeMainVC() {
        _mainViewController?.removeFromParent()
        _mainViewController?.view.removeFromSuperview()
    }

    private func showAdsIfNeeded() {
        if  !MVConfigModel.isVIP() && _isShownAgreement && self.launchViewController.view.superview != nil {
//            AppOpenAdManager.shared.showAdIfAvailable(viewController: self)
            AdmobAdsManager.showInterstitial0(force:true, in: self) { _,_,_ in
            }
//            // 提前切换广告下面的界面
//            if AppOpenAdManager.shared.isShowingAd {
//                self.hideLaunchScreenWhenAdsDidShow()
//            }
        }
    }
    
    func showAdsWhenDidBecomeActive() {
        if !MVConfigModel.isVIP() && _isShownAgreement {
//            AppOpenAdManager.shared.showAdIfAvailable(viewController: self)
            AdmobAdsManager.showInterstitial0(force:true, in: self) { _,_,_ in
            }
        }
    }
    
    private func hideAtLauchIfNeeded(isTimeout: Bool=false) {
        guard let lauchVC = _launchViewController, lauchVC.view.superview != nil else { return }
        
        //已经获取到数据,vip用户直接跳过; 超时都跳过
        if MVConfigModel.isVIP() || isTimeout {
            mainTransition()
        } else {
            //非vip用户返回数据未超时, 再等4s超时, 给广告返回争取时间
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.hideAtLauchIfNeeded(isTimeout: true)
            }
        }
    }
    
    private func showLauchScreen() {
        let vc = self.launchViewController
        self.view.addSubview(vc.view)
        self.addChild(vc)
    }
    
    let reachability = try! Reachability()
    func registerReachability() {

        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                debugPrint("Reachable via WiFi")
            } else {
                debugPrint("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { [weak self] _ in
            debugPrint("Network not reachable")
            if CTCellularData().restrictedState != .restrictedStateUnknown {
                self?.showAlert(title: "Network not reachable", message: "", buttonTitles: ["OK"])
            }
        }

        do {
            try reachability.startNotifier()
        } catch {
            debugPrint("Unable to start notifier")
        }
    }
    
}

extension MVRootViewController: AdsProtocol {
    func adDidDismissFullScreenContent() {
        mainTransition()
    }
    func didLoadAd() {
        showAdsIfNeeded()
    }
}

//extension MVRootViewController: AppOpenAdManagerDelegate {
//    func appOpenAdManagerAdDidComplete(_ appOpenAdManager: AppOpenAdManager) {
//        mainTransition()
//    }
//
//    func appOpenAdManagerAdDidLoad(_ appOpenAdManager: AppOpenAdManager) {
//        showAdsIfNeeded()
//    }
//}

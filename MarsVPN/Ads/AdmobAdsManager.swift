//
//  AppRewardAdManager.swift
//  GOGOVPN
//
//  Created by Justin on 2022/9/26.
//

import Foundation
import AppTrackingTransparency

class AdmobAdsManager {
    static let shared = AdmobAdsManager()
    lazy var interstitialAd0: GMAds? = {
        return GMAds(adUnitID: GMAdsInterstitial0)
    }()
//    var interstitialAd0: GMAds?
    var interstitialAd1: GMAds?
    var interstitialAd2: GMAds?

    static func showInterstitial0(force:Bool=true, in viewController: UIViewController, completion: AdmobAdsCompletion? = nil) {
        ATTrackingManager.requestTrackingAuthorization { (status) in
            DispatchQueue.main.async {
                switch status {
                case .denied:
                    debugPrint("AuthorizationSatus is denied")
                case .notDetermined:
                    debugPrint("AuthorizationSatus is notDetermined")
                case .restricted:
                    debugPrint("AuthorizationSatus is restricted")
                case .authorized:
                    debugPrint("AuthorizationSatus is authorized")
                @unknown default: break
                }
                
                shared.showInterstitial0(force: force, in: viewController, completion: completion)
            }
        }
    }
    static func showInterstitial1(force:Bool=true, in viewController: UIViewController, completion: AdmobAdsCompletion? = nil) {
        ATTrackingManager.requestTrackingAuthorization { (status) in
            DispatchQueue.main.async {
                switch status {
                case .denied:
                    debugPrint("AuthorizationSatus is denied")
                case .notDetermined:
                    debugPrint("AuthorizationSatus is notDetermined")
                case .restricted:
                    debugPrint("AuthorizationSatus is restricted")
                case .authorized:
                    debugPrint("AuthorizationSatus is authorized")
                @unknown default: break
                }
                
                shared.showInterstitial1(force: force, in: viewController, completion: completion)
            }
        }
    }
    static func showInterstitial2(force:Bool=true, in viewController: UIViewController, completion: AdmobAdsCompletion? = nil) {
        ATTrackingManager.requestTrackingAuthorization { (status) in
            DispatchQueue.main.async {
                switch status {
                case .denied:
                    debugPrint("AuthorizationSatus is denied")
                case .notDetermined:
                    debugPrint("AuthorizationSatus is notDetermined")
                case .restricted:
                    debugPrint("AuthorizationSatus is restricted")
                case .authorized:
                    debugPrint("AuthorizationSatus is authorized")
                @unknown default: break
                }
                
                shared.showInterstitial2(force: force, in: viewController, completion: completion)
            }
        }
    }
    
    private func showInterstitial0(force:Bool=true, in viewController: UIViewController, completion: AdmobAdsCompletion? = nil) {
        var interstitialAd = interstitialAd0
        if interstitialAd == nil {
            interstitialAd0 = GMAds(viewController, adUnitID: GMAdsInterstitial0)
            interstitialAd = interstitialAd0
        } else {
            interstitialAd?.viewController = viewController
        }

        interstitialAd?.showInterstitial(force: force, duration: 3, completion: completion)
    }
    private func showInterstitial1(force:Bool=true, in viewController: UIViewController, completion: AdmobAdsCompletion? = nil) {
        var interstitialAd = interstitialAd1
        if interstitialAd == nil {
            interstitialAd1 = GMAds(viewController, adUnitID: GMAdsInterstitial1)
            interstitialAd = interstitialAd1
        } else {
            interstitialAd?.viewController = viewController
        }

        interstitialAd?.showInterstitial(force: force, duration: 3, completion: completion)
    }
    private func showInterstitial2(force:Bool=true, in viewController: UIViewController, completion: AdmobAdsCompletion? = nil) {
        var interstitialAd = interstitialAd2
        if interstitialAd == nil {
            interstitialAd2 = GMAds(viewController, adUnitID: GMAdsInterstitial2)
            interstitialAd = interstitialAd2
        } else {
            interstitialAd?.viewController = viewController
        }

        interstitialAd?.showInterstitial(force: force, duration: 3, completion: completion)
    }
}

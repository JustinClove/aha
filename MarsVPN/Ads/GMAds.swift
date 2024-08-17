//
//  LXAdsFactory.swift
//  GOGOVPN
//
//  Created by Justin on 2022/8/8.
//

import Foundation
import UIKit
import GoogleMobileAds

class GMAds: NSObject, AdsLoadProtocol {
    var dismiss: EmptyCompletion?
    
    weak var viewController: UIViewController?
    weak var delegate: AdsProtocol?
    var dismissNew: AdmobAdsCompletion?
    var _adsId = GMAdsInterstitial0
    var isShowing = false
    internal var _adValue: GADAdValue?

    var interstitial: GADInterstitialAd?
    init(_ viewController: UIViewController? = nil, adUnitID: String = GMAdsInterstitial0) {
        super.init()
        self.viewController = viewController
        _adsId = adUnitID
//        self.loadInterstitial()
    }
}

extension GMAds : GADFullScreenContentDelegate {
                               
    /// Tells the delegate that the ad failed to present full screen content.
      func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
          debugPrint("Ad did fail to present full screen content.")
          self.adDidDismissFullScreenContent()
          isShowing = false
      }

      /// Tells the delegate that the ad will present full screen content.
      func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
          debugPrint("Ad will present full screen content.")
          isShowing = true
      }

      /// Tells the delegate that the ad dismissed full screen content.
      func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
          self.adDidDismissFullScreenContent()
          debugPrint("Ad did dismiss full screen content.")
          isShowing = false
      }
}

extension GMAds {
    func loadInterstitial() {
        interstitial = nil
        _adValue = nil

        let request = GADRequest()
        GADInterstitialAd.load(
          withAdUnitID: _adsId, request: request
        ) { (ad, error) in
            if let error = error {
              debugPrint("Failed to load interstitial ad with error: \(error)")
              return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
            self.interstitial?.paidEventHandler = { [weak self] adValue in
                self?._adValue = adValue
            }
            self.didLoadAd()
        }
    }
    
    func showInterstitial(force: Bool=false, duration: Double=3, completion: AdmobAdsCompletion?=nil) {
        if force {
            self.admobShowInterstitialForce(duration: duration, completion: completion)
        } else {
            self.admobShowInterstitial(completion: completion)
        }
    }
    
    private func admobShowInterstitial(completion: AdmobAdsCompletion?=nil) {
        if interstitial != nil, let vc = self.viewController {
            self.isShowing = true
            interstitial?.present(fromRootViewController: vc)
            dismissNew = completion
        } else {
            debugPrint("Ad wasn't ready")
            loadInterstitial()
            completion?(nil, nil, nil)
        }
    }
    
    private func admobShowInterstitialForce(duration: Double=3, completion: AdmobAdsCompletion? = nil) {
        if interstitial != nil, let vc = self.viewController {
            self.isShowing = true
            interstitial?.present(fromRootViewController: vc)
            dismissNew = completion
            return
        }
        
        if let vc = self.viewController {
            var isTimeout = false
            var occrurError = false

            let request = GADRequest()
            GADInterstitialAd.load(
              withAdUnitID: _adsId, request: request
            ) { (ad, error) in
                if let error = error {
                    occrurError = true
                    
                  debugPrint("Failed to load interstitial ad with error: \(error)")
                    if isTimeout == false {
                        completion?(nil, nil, true)
                    } else {
                        // has been completion
                    }
                  return
                }
                self.interstitial = ad
                self.interstitial?.fullScreenContentDelegate = self
                self.interstitial?.paidEventHandler = { [weak self] adValue in
                    self?._adValue = adValue
                }

                if isTimeout == false {
                    self.isShowing = true
                    self.interstitial?.present(fromRootViewController: vc)
                    self.dismissNew = completion
                } else {
                    // has been completion
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                if self.isShowing == false {
                    isTimeout = true

                    if occrurError == false {
                        completion?(nil, nil, true)
                    }
                }
            }
        } else {
            debugPrint("showInterstitialForce Ad wasn't ready")
            completion?(nil, nil, false)
        }
    }

    
    func shouldShowInterstitial() -> Bool {
//        #if DEBUG
//        return false
//        #endif
//
        let result = interstitial != nil
//        if !result {
//            loadInterstitial()
//        }
        return result
    }
    
    func didLoadAd() {
        self.delegate?.didLoadAd?()
    }
    
    func adDidDismissFullScreenContent() {
        self.interstitial = nil
        self.delegate?.adDidDismissFullScreenContent()
        self.dismissNew?(_adValue, nil, false)
//        self.loadInterstitial()
    }
}

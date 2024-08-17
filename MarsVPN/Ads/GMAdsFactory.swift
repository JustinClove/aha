//
//  GMAdsFactory.swift
//  GOGOVPN
//
//  Created by Justin on 2022/8/8.
//

import Foundation
import UIKit
import GoogleMobileAds

public typealias AdmobAdsCompletion = (GADAdValue?, GADAdReward?, Bool?) -> ()

protocol AdsLoadProtocol: AdsProtocol {
    var delegate: AdsProtocol? {set get}
    var dismiss: EmptyCompletion? {set get}
    func loadInterstitial()
    func showInterstitial(completion: EmptyCompletion?)
    func shouldShowInterstitial() -> Bool
}

extension AdsLoadProtocol {
    func showInterstitial(completion: EmptyCompletion? = nil) {
        
    }
}

@objc protocol AdsProtocol {
    @objc optional func didLoadAd()
    func adDidDismissFullScreenContent()
}

class GMAdsFactory: NSObject {

    class func interstitialAds(_ viewController: UIViewController, delegate: AdsProtocol) -> AdsLoadProtocol {
        return admobAds(viewController, delegate: delegate)
    }
    
    class func admobAds(_ viewController: UIViewController, delegate: AdsProtocol) -> GMAds {
        let ads = GMAds(viewController)
        ads.delegate = delegate
        return ads
    }
    class func admobAdsLaunch(_ viewController: UIViewController, delegate: AdsProtocol) -> GMAds {
        let ads = GMAds(viewController, adUnitID: GMAdsInterstitial0)
        ads.delegate = delegate
        return ads
    }
}


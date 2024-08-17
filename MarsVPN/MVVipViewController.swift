//
//  MVVipViewController.swift
//  FastVPN
//
//  Created by Justin on 2022/9/27.
//

import Foundation

class MVVipViewController: MVFreeViewController {
    
    override func reloadData() {
        locations = [NodeModel].init(MVDataManager.shared.vipLocations)
        tableView.reloadData()
    }
    
//    func pushVipController() {
//        debugPrint("pushVipController")
//        let vc = MVPremiumViewController()
//        self.navigationController?.pushViewController(vc)
//    }
    
    func showPremiumIfNeeded() -> Bool {
        
        let vc = MVPremiumViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true)

        vc.complete = { [unowned vc] (result, errMsg) in
            vc.dismiss(animated: true) {
            }
        }
        
        return false
    }

}

extension MVVipViewController {
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard MVConfigModel.isVIP() else {
            self.showPremiumIfNeeded()
            return nil
        }
        return indexPath
    }
}

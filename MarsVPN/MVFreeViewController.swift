//
//  EditProfileViewController.swift
//  Kinker
//
//  Created by clove on 8/3/20.
//  Copyright © 2020 personal.Justin. All rights reserved.
//

import Foundation

class MVFreeViewController: LXBaseTableViewController {
    
    var locations = [NodeModel]()
    var selectedBlock: ((NodeModel)->())?
                
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = .backgroundColor
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        self.tableView.rowHeight = 66
        self.tableView.register(MVLocationCell.self, forCellReuseIdentifier: "MVLocationCell")
        self.tableView.separatorStyle = .none
        self.tableView.separatorColor = .clear
        self.tableView.contentInset = .zero
        
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func reloadData() {
        locations = [NodeModel].init(MVDataManager.shared.freeLocations)
        tableView.reloadData()
    }
}

extension MVFreeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MVLocationCell", for: indexPath) as! MVLocationCell
        guard locations.count > indexPath.row else { return cell }
        let model = locations[indexPath.row]
        
        cell.update(model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
        
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MVLocationCell {
            cell.isSelected = false
        }

        guard locations.count > indexPath.row else { return }
        let model = locations[indexPath.row]
        self.selectedBlock?(model)
    }
}


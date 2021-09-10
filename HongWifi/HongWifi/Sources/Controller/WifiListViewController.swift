//
//  WifiListViewController.swift
//  HongWifi
//
//  Created by danhan on 2021/09/05.
//

import Foundation
import UIKit

class WifiListViewController: UITableViewController {

    var wifisDataSource = wifiDataSource()
    
    @IBOutlet var storedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storedTableView.separatorStyle = .none
        storedTableView.showsVerticalScrollIndicator = false
        
        
    }

    //MARK: - Tableview Datasource Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wifisDataSource.numbersOfWifi()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoredWifiCell", for: indexPath) as! StoredWifiCell
        
        cell.nickNameLabel.text = wifisDataSource.wifis[indexPath.row].nickname
        cell.wifiNameLabel.text = wifisDataSource.wifis[indexPath.row].wifiName
        cell.wifiPasswordLabel.text = wifisDataSource.wifis[indexPath.row].wifiPassword
        
        cell.selectionStyle = .none  // 클릭 배경생상 없애기
        
        return cell
    }
    
    //MARK: - TableView Edit
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            wifisDataSource.remove(at: indexPath, to: tableView)
        }
    }
}

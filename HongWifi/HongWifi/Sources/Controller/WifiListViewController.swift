//
//  WifiListViewController.swift
//  HongWifi
//
//  Created by danhan on 2021/09/05.
//

import Foundation
import UIKit
import NetworkExtension

class WifiListViewController: UITableViewController {

    var wifisDataSource = wifiDataSource()
    
    @IBOutlet var storedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storedTableView.separatorStyle = .none // cell 구분선 제거
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // wifi 연결
        let SSID = wifisDataSource.wifis[indexPath.row].wifiName
        let passphrase = wifisDataSource.wifis[indexPath.row].wifiPassword
        
        let wiFiConfig = NEHotspotConfiguration(ssid: SSID!, passphrase: passphrase!, isWEP: false)

            NEHotspotConfigurationManager.shared.apply(wiFiConfig) { error in
              if let error = error {
                print(error.localizedDescription)
              }
              else {
                print("connection successful")
              }
            }
    }
    
    //MARK: - TableView Edit Methods
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        // 왼쪽으로 밀어서 cell 삭제
        if editingStyle == .delete {
            wifisDataSource.remove(at: indexPath, to: tableView)
        }
    }
    
    @IBAction func didTapCameraButton(_ sender: Any) {
        // 카메라 화면으로 이동
    }
    
}

//
//  wifiDataSource.swift
//  HongWifi
//
//  Created by danhan on 2021/09/09.
//

import Foundation
import UIKit

class wifiDataSource {
    var wifis: [wifi]
    
    static func generateWifiData() -> [wifi] {
        return [
            HongWifi.wifi(nickname: "Wifi Nickname", wifiName: "Wifi Name", wifiPassword: "Wifi Password"),
            HongWifi.wifi(nickname: "tomtom", wifiName: "tomtom wifi", wifiPassword: "abcdefg")
        ]
    }
    
    init() {
        wifis = wifiDataSource.generateWifiData()
    }
    
    func numbersOfWifi() -> Int {
        return wifis.count
    }
    
    func append(wifi: wifi, to tableView: UITableView) {
        wifis.append(wifi)
        tableView.insertRows(at: [IndexPath(row: wifis.count-1, section: 0)], with: .automatic)
    }
    
    func remove(at indexPath: IndexPath, to tableView: UITableView) {
        wifis.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func wifi(at indexPath: IndexPath) -> wifi {
        return wifis[indexPath.row]
    }
}

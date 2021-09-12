//
//  wifiDataSource.swift
//  HongWifi
//
//  Created by danhan on 2021/09/09.
//

import Foundation
import UIKit

class WifiDataSource {
  var wifis: [Wifi]
  
  static func generateWifiData() -> [Wifi] {
    return [
      HongWifi.Wifi(nickname: "Wifi_Nickname", wifiName: "Wifi_Name", wifiPassword: "Wifi_Password"),
      
      HongWifi.Wifi(nickname: "Tutorial", wifiName: "Press top camera button", wifiPassword: "example is below"),
      HongWifi.Wifi(nickname: "Cafe Namu Wifi", wifiName: "U+Net7148_5G", wifiPassword: "0665765K#8"),
      HongWifi.Wifi(nickname: "Made by", wifiName: "Dayeon, Minji, Jaeyong", wifiPassword: ""),
    ]
  }
  
  init() {
    let standard = UserDefaults.standard
    if let wifis = standard.array(forKey: "wifis") as? [Wifi] {
      self.wifis = wifis
    } else {
      wifis = WifiDataSource.generateWifiData()
    }

  }
  
  func numbersOfWifi() -> Int {
    return wifis.count
  }
  
  func append(wifi: Wifi, to tableView: UITableView) {
    wifis.append(wifi)
    tableView.insertRows(at: [IndexPath(row: wifis.count-1, section: 0)], with: .automatic)
  }
  
  func remove(at indexPath: IndexPath, to tableView: UITableView) {
    wifis.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }
  
  func wifi(at indexPath: IndexPath) -> Wifi {
    return wifis[indexPath.row]
  }
}

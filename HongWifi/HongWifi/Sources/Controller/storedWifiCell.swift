//
//  storedWifiCell.swift
//  HongWifi
//
//  Created by danhan on 2021/09/07.
//

import UIKit

class StoredWifiCell: UITableViewCell {

    
    @IBOutlet weak var wifiView: UIView!
    @IBOutlet weak var wifiBackgroundView: UIView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var wifiNameLabel: UILabel!
    @IBOutlet weak var wifiPasswordLabel: UILabel!
    @IBOutlet weak var unconnectedBackgroundView: UIView!
    @IBOutlet weak var unconnectedImage: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        wifiBackgroundView.layer.cornerRadius = 25
        wifiBackgroundView.layer.shadowOpacity = 0.08
        wifiBackgroundView.layer.shadowOffset = CGSize(width: 1, height: 3)
        wifiBackgroundView.layer.shadowRadius = 1
        
        unconnectedBackgroundView.layer.cornerRadius = 25
        
    }
}

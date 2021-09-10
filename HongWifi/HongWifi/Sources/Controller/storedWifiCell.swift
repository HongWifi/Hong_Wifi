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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if isSelected {
            wifiBackgroundView.layer.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.8, blue: 0.8823529412, alpha: 1)
            unconnectedBackgroundView.layer.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.7529411765, blue: 0.8823529412, alpha: 1)
            wifiNameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            wifiPasswordLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            unconnectedImage.image = UIImage(named: "checkmark")

        } else {
            wifiBackgroundView.layer.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9137254902, blue: 0.9176470588, alpha: 1)
            unconnectedBackgroundView.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            wifiNameLabel.textColor = #colorLiteral(red: 0.6941176471, green: 0.7137254902, blue: 0.7294117647, alpha: 1)
            wifiPasswordLabel.textColor = #colorLiteral(red: 0.6941176471, green: 0.7137254902, blue: 0.7294117647, alpha: 1)
            unconnectedImage.image = UIImage(named: "wifiicon")
        }
    }
}

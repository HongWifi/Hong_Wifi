//
//  CopyWifiController.swift
//  HongWifi
//
//  Created by M-22 on 2021/09/07.
//

import Foundation
import UIKit
import NetworkExtension

class CopyWifiController: UIViewController, UITextFieldDelegate {

//    let wiFiConfig = NEHotspotConfiguration(ssid: "U+NetA214", passphrase: "952G@8094E", isWEP: false)
    
    @IBOutlet weak var resultsView: UITextView!
    
    @IBAction func goBackButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func connectButtonPressed(_ sender: UIButton) {
          
//        //    NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: ssid)
//            NEHotspotConfigurationManager.shared.apply(wiFiConfig) {error in
//              if let error = error {
//                print(error.localizedDescription)
//              }
//              else {
//                
//              }
//                
//            }
    
        let viewController: UIViewController = UIStoryboard(name: "Popup1", bundle: nil).instantiateViewController(withIdentifier: "Popup1") as UIViewController
        present(viewController, animated: false, completion: nil)
        
    }
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var wifiNameView: UIView!
    @IBOutlet weak var wifiPasswordView: UIView!
    
    @IBOutlet weak var wifiNameTextfield: UITextField! {
        didSet {
            wifiNameTextfield.delegate = self
        }
    }
    @IBOutlet weak var wifiPasswordTextfield: UITextField!{
        didSet {
            wifiNameTextfield.delegate = self
        }
    }
    
    @IBAction func showPopup(_ sender: Any) {
           // PopupViewController가 나와야 하는 부분.
           
           
           let storyBoard = UIStoryboard.init(name: "PopupViewController", bundle: nil)    // PopupViewController 라는 이름을 가진 스토리보드를 가져옴
           
           let popupVC = storyBoard.instantiateViewController(identifier: "popupVC")  // 뷰컨트롤러를 불러오는 함수. identifier는 뷰컨트롤러의 storyboard ID.
           
           popupVC.modalPresentationStyle = .overCurrentContext    //  투명도가 있으면 투명도에 맞춰서 나오게 해주는 코드(뒤에있는 배경이 보일 수 있게)
           self.present(popupVC, animated: false, completion: nil)
       }
    
    override func viewDidLoad() {
    super.viewDidLoad()
        firstView.layer.cornerRadius = 40
        secondView.layer.cornerRadius = 35
        wifiNameView.layer.cornerRadius = 10
        wifiPasswordView.layer.cornerRadius = 10
        resultsView.layer.cornerRadius = 35
        resultsView.textContainer.lineFragmentPadding = 28
        
        resultsView.text = "와이파이 이름: mooyahong 와이파이 비번: 1234abcd!"
        
        
        
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_textfield: UITextField) -> Bool {
        wifiNameTextfield.resignFirstResponder()
        wifiPasswordTextfield.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillAppear(noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            self.view.frame.origin.y = 0
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y -= keyboardHeight
        }
    }
    
    @objc func keyboardWillDisappear(noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            self.view.frame.origin.y = 0
        }
    }

}

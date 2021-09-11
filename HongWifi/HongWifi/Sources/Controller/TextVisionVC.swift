//
//  CopyWifiController.swift
//  HongWifi
//
//  Created by M-22 on 2021/09/07.
//

import Foundation
import UIKit
import NetworkExtension

class TextVisionVC: UIViewController, UITextFieldDelegate {
  
  //    let wiFiConfig = NEHotspotConfiguration(ssid: "U+NetA214", passphrase: "952G@8094E", isWEP: false)
  
  @IBOutlet weak var resultsView: UITextView!
  
  @IBAction func goBackButtonPressed(_ sender: UIButton) {
  }
  
  @IBAction func connectButtonPressed(_ sender: UIButton) {
    
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

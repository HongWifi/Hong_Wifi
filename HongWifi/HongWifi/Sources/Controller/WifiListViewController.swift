//
//  WifiListViewController.swift
//  HongWifi
//
//  Created by danhan on 2021/09/05.
//

import Foundation
import UIKit
import NetworkExtension
import SnapKit
import MLImage
import MLKit

class WifiListViewController: UITableViewController {
  
  var wifisDataSource = WifiDataSource()

  lazy var picker = UIImagePickerController()
  lazy var activity = UIActivityIndicatorView()
  var selectedImage: UIImage?
  
  @IBOutlet var storedTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Muyahong Wifi"
    activity.style = .large
    activity.hidesWhenStopped = true
    view.addSubview(activity)
    activity.snp.makeConstraints { make in
      make.centerX.centerY.equalToSuperview()
    }
    picker.delegate = self
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
   
   
    activity.startAnimating()
    NEHotspotConfigurationManager.shared.apply(wiFiConfig) { [weak self] error in
      if let error = error {
        self?.activity.stopAnimating()
        print(error.localizedDescription)
      }
      else {
        self?.activity.stopAnimating()
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
    
    let alert = UIAlertController(title: "사진 선택", message: nil, preferredStyle: .actionSheet)
    let library = UIAlertAction(title: "사진앨범", style: .default) { (action) in
      self.openLibrary()
    }
    let camera = UIAlertAction(title: "카메라", style: .default) { (action) in
      self.openCamera()
      
    }
    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alert.addAction(library)
    alert.addAction(camera)
    alert.addAction(cancel)
    present(alert, animated: true, completion: nil)
  }
  
  
  private func openLibrary() {
    picker.sourceType = .photoLibrary
    picker.allowsEditing = true
    picker.modalPresentationStyle = .fullScreen
    present(picker, animated: true, completion: nil)
  }
  
  private func openCamera() {
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      picker.sourceType = .camera
      picker.allowsEditing = true
      picker.modalPresentationStyle = .fullScreen
      present(picker, animated: true, completion: nil)
    } else {
      print("Camera not available")
    }
    
  }
  
}

extension WifiListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let _ = info[.originalImage] as? UIImage, let editedImage = info[.editedImage] as? UIImage {
      selectedImage = editedImage
      self.dismiss(animated: true, completion: nil)
      
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
        let sb = UIStoryboard.init(name: "TextVision", bundle: nil)
        guard let vc = sb.instantiateViewController(identifier: "TextVisionVC") as? TextVisionVC else { return }
        vc.image = editedImage
        self.navigationController?.pushViewController(vc, animated: true)
      }
    }
  }
  
  @objc func savedImage(image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer?) {
    if let error = error {
      print(error)
      return
    }
    print("success")
  }
}

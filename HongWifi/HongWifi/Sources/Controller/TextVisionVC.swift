//
//  CopyWifiController.swift
//  HongWifi
//
//  Created by M-22 on 2021/09/07.
//

import Foundation
import UIKit
import NetworkExtension
import MLImage
import MLKit
import AVFoundation

class TextVisionVC: UIViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var ssidTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  var resultsText = ""
  var nickName = ""
  var image: UIImage?
  let koreanOptions = KoreanTextRecognizerOptions()
  lazy var koreanTextRecognizer = TextRecognizer.textRecognizer(options:koreanOptions)
  
  lazy var activity = UIActivityIndicatorView()
  private lazy var annotationOverlayView: UIView = {
    precondition(isViewLoaded)
    let annotationOverlayView = UIView(frame: .zero)
    annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
    annotationOverlayView.clipsToBounds = true
    return annotationOverlayView
  }()
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTextView()
    setupNavigationBar()
    setupOverlayView()
    startTetVision()
    setupActivity()
    setupObserver()
    self.addKeyboardDismissTapGesture()
  }
  
  func setupActivity() {
    activity.style = .large
    activity.hidesWhenStopped = true
    view.addSubview(activity)
    activity.snp.makeConstraints { make in
      make.centerX.centerY.equalToSuperview()
    }
  }
  
  func setupTextView() {
    textView.isEditable = false
    textView.layer.cornerRadius = 30
    textView.layer.masksToBounds = true
  }
  
  func setupNavigationBar() {
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark.seal"), style: .plain, target: self, action: #selector(storeButtonPressed))
    self.navigationItem.rightBarButtonItem?.tintColor = .systemIndigo
    
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(backButtonPressed))
    self.navigationItem.leftBarButtonItem?.tintColor = .systemIndigo
    self.title = "Wifi 연결 및 저장"
  }
  
  
  private func setupObserver() {
    let center = NotificationCenter.default
    
    center.addObserver(self, selector: #selector(animateViewForKeyboardShow(_:)),
                       name: UIResponder.keyboardWillShowNotification, object: nil)
    center.addObserver(self, selector: #selector(animateViewForKeyboardHide(_:)),
                       name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc func animateViewForKeyboardShow(_ notification: NSNotification) {
    guard self == UIViewController.getVisibleController() else { return }
    
    self.animateWithKeyboard(notification) { [weak self] keyboardFrame, keyboardDuration in
      guard let self = self                         else { return }
      
      guard let keyboardDuration = keyboardDuration else { return }
      
      self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (keyboardFrame?.height ?? 300), right: 0)
      
      UIView.animate(withDuration: keyboardDuration) { self.view.layoutIfNeeded() }
    }
  }
  
  @objc func animateViewForKeyboardHide(_ notification: NSNotification) {
    guard self == UIViewController.getVisibleController() else { return }
    
    self.animateWithKeyboard(notification) { [weak self] _, keyboardDuration in
      guard let self = self                         else { return }
      guard let keyboardDuration = keyboardDuration else { return }
      
      
      self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      
      UIView.animate(withDuration: keyboardDuration) { self.view.layoutIfNeeded() }
    }
  }
  
  @objc func storeButtonPressed() {
    print("storeButtonPressed")
    if let name = ssidTextField.text, let pwd = passwordTextField.text {
      let alert = UIAlertController(title: "Name your Wifi Nickname", message: "리스트에 보여질 와이파이 이름을 정해주세요. (SSID X)", preferredStyle: .alert)
      let ok = UIAlertAction(title: "connect and store", style: .default) { [weak self] _ in
        self?.storeInUserDefaults(name, pwd)
      }
      
      alert.addTextField { textField in
        textField.textColor = .systemIndigo
        textField.placeholder = "집 앞 스타벅스 와이파이"
        self.nickName = textField.text ?? ""
      }
      
      let cancel = UIAlertAction(title: "cancle", style: .cancel) { (cancel) in
      }
      
      alert.addAction(cancel)
      alert.addAction(ok)
      self.present(alert, animated: true, completion: nil)
      
    } else {
      let alert = UIAlertController(title: "Hey!", message: "You should fill wifi name and pwd", preferredStyle: .alert)
      let ok = UIAlertAction(title: "Ok", style: .cancel) { _ in
      }
      alert.addAction(ok)
      self.present(alert, animated: true, completion: nil)
      
    }
    
    
  }
  
  @objc func backButtonPressed() {
    print("backButtonPressed")
    self.navigationController?.popViewController(animated: true)
  }
  
  func storeInUserDefaults(_ ssid: String, _ pwd: String) {
    let newWifi = Wifi(nickname: nickName, wifiName: ssid, wifiPassword: pwd)
    
    let wiFiConfig = NEHotspotConfiguration(ssid: ssid, passphrase: pwd, isWEP: false)
   
    activity.startAnimating()
    NEHotspotConfigurationManager.shared.apply(wiFiConfig) { [weak self] error in
      if let error = error {
        self?.activity.stopAnimating()
        print(error.localizedDescription)
      }
      else {
        self?.activity.stopAnimating()
        
        let standard = UserDefaults.standard
        if let wifiDatas = standard.array(forKey: "wifis") as? [Wifi] {
          var wifiDatas = wifiDatas
          wifiDatas.append(newWifi)
          standard.setValue(wifiDatas, forKey: "wifis")
          
        } else {
          UserDefaults.standard.setValue([newWifi], forKey: "wifis")
        }
        self?.navigationController?.popViewController(animated: true)
        print("connection successful")
      }
    }
    
    
    
  }
  
  func setupOverlayView() {
    imageView.addSubview(annotationOverlayView)
    NSLayoutConstraint.activate([
      annotationOverlayView.topAnchor.constraint(equalTo: imageView.topAnchor),
      annotationOverlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
      annotationOverlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
      annotationOverlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
    ])
  }
  
  func startTetVision() {
    
    updateImageView(with: image!) { [weak self] in
      self?.detectTextOnDevice(image: self?.imageView.image, detectorType: .detectTextKoreanOnDevice)
    }
  }
  
  
  /// Updates the image view with a scaled version of the given image.
  private func updateImageView(with image: UIImage, completion: @escaping ()->Void) {
    
    weak var weakSelf = self
    DispatchQueue.global(qos: .userInitiated).async {
      // Scale image while maintaining aspect ratio so it displays better in the UIImageView.
      let scaledImage = image.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), resizingMode: .stretch)
      
      DispatchQueue.main.async {
        weakSelf?.imageView.image = scaledImage
        completion()
      }
      
    }
    
  }
  
  
  private func detectTextOnDevice(image: UIImage?, detectorType: DetectorPickerRow) {
    guard let image = image else { return }
    // [START init_text]
    var options: CommonTextRecognizerOptions
    if detectorType == .detectTextChineseOnDevice {
      options = ChineseTextRecognizerOptions.init()
    } else if detectorType == .detectTextDevanagariOnDevice {
      options = DevanagariTextRecognizerOptions.init()
    } else if detectorType == .detectTextJapaneseOnDevice {
      options = JapaneseTextRecognizerOptions.init()
    } else if detectorType == .detectTextKoreanOnDevice {
      options = KoreanTextRecognizerOptions.init()
    } else {
      options = TextRecognizerOptions.init()
    }
    
    let onDeviceTextRecognizer = TextRecognizer.textRecognizer(options: options)
    // [END init_text]
    
    // Initialize a `VisionImage` object with the given `UIImage`.
    let visionImage = VisionImage(image: image)
    visionImage.orientation = image.imageOrientation
    
    self.resultsText += "Running On-Device Text Recognition...\n"
    process(visionImage, with: onDeviceTextRecognizer)
  }
  
  private func process(_ visionImage: VisionImage, with textRecognizer: TextRecognizer?) {
    weak var weakSelf = self
    textRecognizer?.process(visionImage) { text, error in
      guard let strongSelf = weakSelf else {
        print("Self is nil!")
        return
      }
      guard error == nil, let text = text else {
        let errorString = error?.localizedDescription ?? "Constants.detectionNoResultsMessage"
        strongSelf.resultsText = "Text recognizer failed with error: \(errorString)"
        strongSelf.showResults()
        return
      }
      // Blocks.
      for block in text.blocks {
        let transformedRect = block.frame.applying(strongSelf.transformMatrix())
        UIUtilities.addRectangle(
          transformedRect,
          to: strongSelf.annotationOverlayView,
          color: UIColor.purple
        )
        
        // Lines.
        for line in block.lines {
          let transformedRect = line.frame.applying(strongSelf.transformMatrix())
          UIUtilities.addRectangle(
            transformedRect,
            to: strongSelf.annotationOverlayView,
            color: UIColor.orange
          )
          
          // Elements.
          for element in line.elements {
            let transformedRect = element.frame.applying(strongSelf.transformMatrix())
            UIUtilities.addRectangle(
              transformedRect,
              to: strongSelf.annotationOverlayView,
              color: UIColor.green
            )
            let label = UILabel(frame: transformedRect)
            label.text = element.text
            label.adjustsFontSizeToFitWidth = true
            strongSelf.annotationOverlayView.addSubview(label)
          }
        }
      }
      
      strongSelf.resultsText += "\(text.text)\n"
      strongSelf.showResults()
    }
  }
  
  private func showResults() {
    let resultsAlertController = UIAlertController(
      title: "Detection Results",
      message: nil,
      preferredStyle: .actionSheet
    )
    
    resultsAlertController.addAction(
      UIAlertAction(title: "OK", style: .destructive) { _ in
        resultsAlertController.dismiss(animated: true, completion: nil)
      }
    )
    resultsAlertController.message = resultsText
    
    resultsAlertController.popoverPresentationController?.sourceView = self.view
    //    present(resultsAlertController, animated: true, completion: nil)
    textView.text = resultsText
    print(resultsText)
  }
  
  private func transformMatrix() -> CGAffineTransform {
    guard let image = imageView.image else { return CGAffineTransform() }
    let imageViewWidth = imageView.frame.size.width
    let imageViewHeight = imageView.frame.size.height
    let imageWidth = image.size.width
    let imageHeight = image.size.height
    
    let imageViewAspectRatio = imageViewWidth / imageViewHeight
    let imageAspectRatio = imageWidth / imageHeight
    let scale =
      (imageViewAspectRatio > imageAspectRatio)
      ? imageViewHeight / imageHeight : imageViewWidth / imageWidth
    
    // Image view's `contentMode` is `scaleAspectFit`, which scales the image to fit the size of the
    // image view by maintaining the aspect ratio. Multiple by `scale` to get image's original size.
    let scaledImageWidth = imageWidth * scale
    let scaledImageHeight = imageHeight * scale
    let xValue = (imageViewWidth - scaledImageWidth) / CGFloat(2.0)
    let yValue = (imageViewHeight - scaledImageHeight) / CGFloat(2.0)
    
    var transform = CGAffineTransform.identity.translatedBy(x: xValue, y: yValue)
    transform = transform.scaledBy(x: scale, y: scale)
    return transform
  }
  
}

private enum DetectorPickerRow: Int {
  case detectFaceOnDevice = 0
  
  case
    detectTextOnDevice,
    detectTextChineseOnDevice,
    detectTextDevanagariOnDevice,
    detectTextJapaneseOnDevice,
    detectTextKoreanOnDevice,
    detectBarcodeOnDevice,
    detectImageLabelsOnDevice,
    detectImageLabelsCustomOnDevice,
    detectObjectsProminentNoClassifier,
    detectObjectsProminentWithClassifier,
    detectObjectsMultipleNoClassifier,
    detectObjectsMultipleWithClassifier,
    detectObjectsCustomProminentNoClassifier,
    detectObjectsCustomProminentWithClassifier,
    detectObjectsCustomMultipleNoClassifier,
    detectObjectsCustomMultipleWithClassifier,
    detectPose,
    detectPoseAccurate,
    detectSegmentationMaskSelfie
  
  static let rowsCount = 20
  static let componentsCount = 1
  
  public var description: String {
    switch self {
    case .detectFaceOnDevice:
      return "Face Detection"
    case .detectTextOnDevice:
      return "Text Recognition"
    case .detectTextChineseOnDevice:
      return "Text Recognition Chinese"
    case .detectTextDevanagariOnDevice:
      return "Text Recognition Devanagari"
    case .detectTextJapaneseOnDevice:
      return "Text Recognition Japanese"
    case .detectTextKoreanOnDevice:
      return "Text Recognition Korean"
    case .detectBarcodeOnDevice:
      return "Barcode Scanning"
    case .detectImageLabelsOnDevice:
      return "Image Labeling"
    case .detectImageLabelsCustomOnDevice:
      return "Image Labeling Custom"
    case .detectObjectsProminentNoClassifier:
      return "ODT, single, no labeling"
    case .detectObjectsProminentWithClassifier:
      return "ODT, single, labeling"
    case .detectObjectsMultipleNoClassifier:
      return "ODT, multiple, no labeling"
    case .detectObjectsMultipleWithClassifier:
      return "ODT, multiple, labeling"
    case .detectObjectsCustomProminentNoClassifier:
      return "ODT, custom, single, no labeling"
    case .detectObjectsCustomProminentWithClassifier:
      return "ODT, custom, single, labeling"
    case .detectObjectsCustomMultipleNoClassifier:
      return "ODT, custom, multiple, no labeling"
    case .detectObjectsCustomMultipleWithClassifier:
      return "ODT, custom, multiple, labeling"
    case .detectPose:
      return "Pose Detection"
    case .detectPoseAccurate:
      return "Pose Detection, accurate"
    case .detectSegmentationMaskSelfie:
      return "Selfie Segmentation"
    }
  }
}

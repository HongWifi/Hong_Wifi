//
//  UIView+Extension.swift
//  HongWifi
//
//  Created by Wody on 2021/09/04.
//

import UIKit

extension UIViewController {
    
    static var rootViewController: UIViewController? {
        return UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController
    }
    
    static func getVisibleController(_ viewController: UIViewController? = UIViewController.rootViewController) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController {
            return getVisibleController(navigationController.visibleViewController)
        } else if let tabbarController = viewController as? UITabBarController {
            return getVisibleController(tabbarController.selectedViewController)
        } else if let presentedController = viewController?.presentedViewController {
            return getVisibleController(presentedController)
        } else {
            return viewController
        }
    }
    
    static func instantiateFromStoryboard(_ name: String = "Main") -> Self? {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let identifier = String(describing: self)
        
        return storyboard.instantiateViewController(withIdentifier: identifier) as? Self
    }
    
    func addKeyboardDismissTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard(_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func animateWithKeyboard(_ notification: NSNotification, animation: (CGRect?, Double?) -> Void) {
        let frameKey         = UIResponder.keyboardFrameEndUserInfoKey
        let keyboardFrame    = (notification.userInfo?[frameKey] as? NSValue)?.cgRectValue
        
        let durationKey      = UIResponder.keyboardAnimationDurationUserInfoKey
        let keyboardDuration = notification.userInfo?[durationKey] as? Double
        
        animation(keyboardFrame, keyboardDuration)
    }
    
}


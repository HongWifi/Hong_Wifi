//
//  Pop-up1Controller.swift
//  HongWifi
//
//  Created by M-22 on 2021/09/11.
//

import UIKit

class Popup1Controller: UIViewController {

    @IBAction func saveWifi(_ sender: UIButton) {
        

        
        let viewController: UIViewController = UIStoryboard(name: "Popup2", bundle: nil).instantiateViewController(withIdentifier: "Popup2") as UIViewController
        present(viewController, animated: false, completion: nil)
       
        
        
    }
    
    @IBAction func dontSaveWifi(_ sender: UIButton) {
        
       // self.dismiss(animated: true, completion: nil)
        
        let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main") as UIViewController
        present(viewController, animated: false, completion: nil)
    }
   
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension UINavigationController {
    func popViewController(animated: Bool, completion:@escaping (()->())) -> UIViewController? {
           CATransaction.setCompletionBlock(completion)
           CATransaction.begin()
           let poppedViewController = self.popViewController(animated: animated)
           CATransaction.commit()
           return poppedViewController
       }
       
       func pushViewController(_ viewController: UIViewController, animated: Bool, completion:@escaping (()->())) {
           CATransaction.setCompletionBlock(completion)
           CATransaction.begin()
           self.pushViewController(viewController, animated: animated)
           CATransaction.commit()
       }
}



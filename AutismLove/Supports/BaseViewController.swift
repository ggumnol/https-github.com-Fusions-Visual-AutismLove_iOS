//
//  BaseViewController.swift
//  AutismLove
//
//  Created by BobbyPhtr on 01/05/21.
//

import Foundation
import UIKit
import SVProgressHUD

class BaseViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultMaskType(.black)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupDefaultNavigationController()
    }
    
    // Global functions
    func showSystemErrorAlert(message : String){
        let alert = UIAlertController.init(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
//        navigationController?.present(alert, animated: true, completion: nil)
        present(alert, animated: true, completion: nil)
    }
    
    func showSystemErrorAlert(with title : String, message : String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
//        navigationController?.present(alert, animated: true, completion: nil)
        present(alert, animated: true, completion: nil)
    }
    
    
    /// Show custom dialog with icon
    /// - Parameters:
    ///   - image: prefers showing icon because the image is small
    ///   - message: alert message
    ///   - onOkAction: do something after closing dialog.
    func showDefaultDialog(with image : UIImage, message : String, onOkAction : (()->Void)?) {
        let alert = ImageAlertViewController.init(alertImage: image, alertDescription: message)
        alert.onOkAction = onOkAction
//        navigationController?.present(alert, animated: true, completion: nil)
        present(alert, animated: true, completion: nil)
    }
    
    func showDefaultDialog(message : String, onOkAction : (()->Void)? ){
        let alert = ImageAlertViewController.init( alertDescription: message)
        alert.onOkAction = onOkAction
//        navigationController?.present(alert, animated: true, completion: nil)
        present(alert, animated: true, completion: nil)
    }
    
    func doSms(phoneNum : String, name : String){
        let sms: String = "sms:\(phoneNum)&body=Hello \(name)!, "
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    }
    
    func doCall(phoneNum : String){
        if let url = URL(string: "tel://\(phoneNum)"),
           UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            print("Error on Launching Call, please check phone number format")
        }
    }
    
}

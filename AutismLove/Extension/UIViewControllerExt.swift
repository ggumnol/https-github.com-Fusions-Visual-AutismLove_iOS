//
//  UIViewControllerExt.swift
//  AutismLove
//
//  Created by Samuel Krisna on 26/04/21.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func navigationTitleLogoImage() {
        let image: UIImage = UIImage(named: "logo")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
//    func navigationLogoWithTitle(){
//
//        let image: UIImage = UIImage(named: "logo")!
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = image
//
//        NSLayoutConstraint.activate([
//            imageView.heightAnchor.constraint(equalToConstant: 40),
//            imageView.widthAnchor.constraint(equalToConstant: 40)
//        ])
//
//        let label = UILabel.init()
//        label.text = title
//        label.textColor = .PRIMARY_DARK
//
//        let vStack = UIStackView.init(arrangedSubviews: [imageView, label])
//        vStack.spacing = 16
//        vStack.alignment = .center
//        vStack.axis = .vertical
//
//        navigationItem.titleView = vStack
//    }
    
    func navigationLeftRightNotification() {
        // Left
        let leftImage = UIImage(named: "ic_public_notification")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImage, style: .plain, target: self, action: #selector(publicNotificationTapped))
        
        // Right
        let rightImage = UIImage(named: "ic_notification")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage, style: .plain, target: self, action: #selector(notificationTapped))
    }
    
    @objc func publicNotificationTapped() {
        navigationController?.pushViewController(PublicNotificationViewController().self, animated: true)
    }
    
    @objc func notificationTapped() {
        navigationController?.pushViewController(PublicNotificationViewController().self, animated: true)
    }
    
    // Hide on Default
    func setupDefaultNavigationController() {
//        hideNavigationController()
        
        // Basic Style
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .default
        title = title?.uppercased()
        navigationController?.navigationItem.backButtonTitle = nil
        navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    func hideNavigationController() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    /// Tell the current navcon to show navigation controller with style. Dont call this if you dont want it to be shown
    /// - Parameter navStyle: Navigation Style.
    func showNavigationController(popToRoot: Bool = false){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [
            .font : UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor : UIColor.PRIMARY_DARK,
        ]
        navigationController?.navigationBar.tintColor = .PRIMARY_DARK
        navigationController?.navigationBar.barTintColor = .white
        
        let insets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        
        navigationController?.navigationBar.backIndicatorImage = UIImage.init(named: "ic_arrow_left_black")!.withAlignmentRectInsets(insets)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage.init(named: "ic_arrow_left_black")!.withAlignmentRectInsets(insets)
    }
    
    func createMessageId(otherUid: String) -> String {
        let currentUid = (Globals.userData?.id)!
        let otherUid = otherUid
        let dateString = Date()
        
        let messageId = "\(otherUid)_\(currentUid)_\(dateString)"
        
        return messageId
    }
}

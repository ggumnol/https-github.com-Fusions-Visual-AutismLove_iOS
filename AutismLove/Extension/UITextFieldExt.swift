//
//  UITextFieldExt.swift
//  AutismLove
//
//  Created by BobbyPhtr on 28/04/21.
//

import Foundation
import UIKit

protocol Keyboarded {
    var addDoneButton : Bool {set get}
}

extension UITextField : Keyboarded {
    @IBInspectable var addDoneButton: Bool {
        get {
            return addDoneButtonOnKeyboard()
        }
        set {
            if newValue {
                _ = addDoneButtonOnKeyboard()
            }
        }
    }
    
    
    func addDoneButtonOnKeyboard()->Bool{
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        done.setTitleTextAttributes([.foregroundColor : Color.SECONDARY_MEDIUM_BLUE], for: .normal)
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
        return true
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    
    func setBottomBorder(color:UIColor) {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func setRightViewImage(image : UIImage?) {
        let imageView = UIImageView.init(image: image)
        imageView.contentMode = .right
        imageView.tintColor =  .black
        self.rightViewMode = .always
        self.rightView = imageView
    }
    
    func setLeftViewImage(image: UIImage?) {
        let imageView = UIImageView.init(image: image)
        imageView.contentMode = .left
        imageView.tintColor =  .black
        self.leftViewMode = .always
        self.leftView = imageView
    }
    
}

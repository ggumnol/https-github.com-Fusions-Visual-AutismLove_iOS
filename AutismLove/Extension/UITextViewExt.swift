//
//  UITextViewExt.swift
//  AutismLove
//
//  Created by Samuel Krisna on 29/05/21.
//

import Foundation
import UIKit

protocol TextViewKeyboarded {
    var addDoneButton : Bool {set get}
}

extension UITextView: TextViewKeyboarded {
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
    
}

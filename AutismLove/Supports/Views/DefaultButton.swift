//
//  DefaultButton.swift
//  AutismLove
//
//  Created by BobbyPhtr on 01/05/21.
//

import UIKit
import Foundation

class DefaultButton : UIButton {
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.alpha = 1.0
            } else {
                self.alpha = 0.5
            }
        }
    }
    
    func secondaryBlueStyle(){
        layer.cornerRadius = 8
        backgroundColor = .SECONDARY_MEDIUM_BLUE
        setTitleColor(.white, for: .normal)
        contentEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func secondaryBlueStyleInactive(){
        layer.cornerRadius = 8
        backgroundColor = .lightGray
        setTitleColor(.white, for: .normal)
        contentEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func primaryBlueStyle() {
        layer.cornerRadius = 8.0
        backgroundColor = .PRIMARY_DARK
        setTitleColor(.white, for: .normal)
    }
    
    func linkStyle() {
        layer.cornerRadius = 8.0
        backgroundColor = .link
        setTitleColor(.white, for: .normal)
    }
    
    func whiteBlueStyle() {
        layer.cornerRadius = 8.0
        layer.borderColor = Color.PRIMARY_DARK.cgColor
        layer.borderWidth = 1
        backgroundColor = .white
        setTitleColor(.PRIMARY_DARK, for: .normal)
    }
    
    func textStyle() {
        setTitleColor(.DARK_GRAY, for: .normal)
        setTitleColor(.BACKGROUND_LIGHT_GRAY, for: .selected)
    }
    
    func lightRedStyle() {
        layer.cornerRadius = 8.0
        backgroundColor = .LIGHT_RED
        setTitleColor(.white, for: .normal)
    }
    
    func redStyle(){
        layer.cornerRadius = 8.0
        backgroundColor = .red
        setTitleColor(.white, for: .normal)
    }
    
}

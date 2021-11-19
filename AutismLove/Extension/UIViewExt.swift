//
//  UIViewExt.swift
//  AutismLove
//
//  Created by Samuel Krisna on 23/04/21.
//

import Foundation
import UIKit

extension UIView{
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        
        layer.addSublayer(border)
    }
    
    func roundCorners(radius: CGFloat){
        layer.cornerRadius = radius
    }
    
    func shadowAndRoundCorner() {
        layer.cornerRadius = 7
        layer.shadowOffset = .init(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowOpacity = 0.25
        layer.masksToBounds = false
    }
    
    func animateBorderColor(toColor: UIColor, duration: Double) {
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = layer.borderColor
        animation.toValue = toColor.cgColor
        animation.duration = duration
        layer.add(animation, forKey: "borderColor")
        layer.borderColor = toColor.cgColor
      }
}

class CheckboxButton: UIView {
    
    var isChecked = false
    
    let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.tintColor = .systemBlue
        image.image = UIImage(systemName: "checkmark")
        
        return image
    }()
    
    override func layoutSubviews() {
        backgroundColor = .systemRed
        addSubview(image)
    }
    
    public func toogle() {
        isChecked = !isChecked
        
        image.isHidden = isChecked
    }
}

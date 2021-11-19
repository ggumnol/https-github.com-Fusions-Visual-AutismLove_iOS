//
//  CustomTextField.swift
//  AutismLove
//
//  Created by BobbyPhtr on 26/04/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CustomTextField : UITextField {
    
    // Constraints
    /// For centered floating label
    private lazy var centerConstraint : NSLayoutConstraint = self.floatingLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    /// When there's a text, move the label at points
    private lazy var upConstraint : NSLayoutConstraint = self.floatingLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 20)
    
    // Parameters
    var isPassword : Bool = true {
        didSet {
            if isPassword {
                self.textContentType = .password
                self.isSecureTextEntry = true
                self.textColor = Color.SECONDARY_MEDIUM_BLUE
            }
        }
    }
    
    private var cornerRadius : CGFloat = 8 {
        didSet {
            borderLayer?.cornerRadius = cornerRadius
        }
    }
    
    private var borderColor : UIColor = Color.SECONDARY_LIGHT_BLUE {
        didSet {
            borderLayer?.borderColor = borderColor.cgColor
        }
    }
    
    private var borderWidth : CGFloat = 2 {
        didSet {
            borderLayer?.borderWidth = borderWidth
        }
    }
    private let padding = UIEdgeInsets.init(top: 16, left: 8, bottom: 0, right: 8)

    // Layers
    private var borderLayer : CALayer?
    private var shadowLayer : CAShapeLayer?
    
    
    private var labelString : String? {
        didSet {
            floatingLabel.text = labelString
        }
    }
    var floatingLabelColor : UIColor = Color.SECONDARY_MEDIUM_BLUE {
        didSet {
            floatingLabel.textColor = floatingLabelColor
            self.setNeedsDisplay()
        }
    }
    var activeBorderColor : UIColor = Color.SECONDARY_MEDIUM_BLUE
    
    // Properties
    let floatingLabel : UILabel = UILabel.init(frame: CGRect.zero)
    let floatingLabelHeight : CGFloat = 12
    
    override var text: String? {
        didSet {
            if text != nil || text != ""{
                self.textAlignment = .left
                moveFloatingLabelUpward()
            } else {
                self.textAlignment = .right
                moveFloatingLabelDownward()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowLayer?.frame = self.bounds
        shadowLayer?.path = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height), cornerRadius: cornerRadius).cgPath
        borderLayer?.frame = self.bounds
    }
    
    private func setup(){
        backgroundColor = .white
        
        addBorderLayer()
        addShadowLayer()
        addFloatingLabel()
        
        // add reactive
        self.addTarget(self, action: #selector(didBeginEditing), for: .editingDidBegin)
        self.addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
    }
    
    private func addShadowLayer(){
        shadowLayer = CAShapeLayer()
        shadowLayer?.fillColor = UIColor.white.cgColor
        shadowLayer!.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        shadowLayer!.shadowOffset = CGSize.init(width:0, height: 2)
        shadowLayer!.shadowRadius = 3.0
        shadowLayer!.shadowOpacity = 0.5
        shadowLayer!.masksToBounds = false
        shadowLayer!.shouldRasterize = true
        layer.insertSublayer(shadowLayer!, at: 0)
    }
    
    private func addBorderLayer() {
        // Reset initial border
        layer.borderWidth = 0.0
        borderStyle = .none
        
        // Create new border
        borderLayer = CALayer.init()
        borderLayer!.borderColor = self.borderColor.cgColor
        borderLayer!.borderWidth = self.borderWidth
        borderLayer!.cornerRadius = self.cornerRadius
        borderLayer!.masksToBounds = true
        layer.addSublayer(borderLayer!)
    }
    
    private func addFloatingLabel(){
        textAlignment = .right
        if self.text == "" {
            self.floatingLabel.textColor = floatingLabelColor
            self.floatingLabel.text = self.labelString
            self.floatingLabel.font = UIFont.boldSystemFont(ofSize: 12)
            self.floatingLabel.layer.backgroundColor = UIColor.white.cgColor
            self.floatingLabel.translatesAutoresizingMaskIntoConstraints = false
            self.floatingLabel.clipsToBounds = false
            self.floatingLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.floatingLabelHeight)
            self.layer.borderColor = self.activeBorderColor.cgColor
            UIView.animate(withDuration: 0.3) {
                self.addSubview(self.floatingLabel)
            }
            
            self.floatingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding.left).isActive = true
            centerConstraint.isActive = true

            // Remove the placeholder
            self.placeholder = ""
        }
        self.bringSubviewToFront(floatingLabel)
        self.setNeedsDisplay()
    }
    
    private func moveFloatingLabelUpward() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.centerConstraint.isActive = false
            self?.upConstraint.isActive = true
            self?.setNeedsLayout()
        }
       
    }
    
    private func moveFloatingLabelDownward() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            if self?.text == "" {
                self?.upConstraint.isActive = false
                self?.centerConstraint.isActive = true
                self?.textAlignment = .right
            }
            self?.setNeedsLayout()
        }
    }
    
    private func removeFloatingLabel(){
        // If text is empty remove the floating label
        if self.text == "" {
            UIView.animate(withDuration: 0.3) {
                self.subviews.forEach{ $0.removeFromSuperview() }
                self.setNeedsDisplay()
            }
            self.placeholder = self.labelString
        }
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    // MARK: Behavior
    @objc func didBeginEditing() {
        self.textAlignment = .left
        borderColor =  Color.SECONDARY_MEDIUM_BLUE
        moveFloatingLabelUpward()
    }
    
    @objc func didEndEditing() {
        borderColor = Color.SECONDARY_LIGHT_BLUE
        moveFloatingLabelDownward()
    }
    
    // MARK: Text input padding
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        // place holder should only follows the leading and end trailing when not editting
        if isEditing {
            let placeHolderInset = UIEdgeInsets.init(top: padding.top, left: padding.left, bottom: 0, right: padding.right)
            return bounds.inset(by: placeHolderInset)
        } else {
            let placeHolderInset = UIEdgeInsets.init(top: 0, left: padding.left, bottom: 0, right: padding.right)
            return bounds.inset(by: placeHolderInset)
        }
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    // MARK: Floating Configuration
    final func setFloatingLabel(_ string : String?) {
        labelString = string
    }
    
    final func setFloatingLabelTitleColor(_ color : UIColor) {
        floatingLabelColor = color
    }
    
}

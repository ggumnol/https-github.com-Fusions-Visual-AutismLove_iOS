//
//  TextCollectionViewCell.swift
//  AutismLove
//
//  Created by Filbert Hartawan on 17/11/21.
//

import UIKit

class TextCollectionViewCell: UICollectionViewCell {

    @IBOutlet var containerV: UIView!
    
    @IBOutlet var textL: UILabel!
    @IBOutlet var readL: UILabel!
    
    @IBOutlet var trailingC: NSLayoutConstraint!
    @IBOutlet var leadingC: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
    
    private func setupViews(){
        layoutIfNeeded()
        containerV.layer.cornerRadius = 10
    }
    
    func setupMyMessage(){
        readL.text = "읽음"
        readL.isHidden = false
        containerV.backgroundColor = .link
        textL.textColor = .white
        leadingC.priority = UILayoutPriority(rawValue: 250)
        trailingC.priority = UILayoutPriority(rawValue: 1000)
    }
    
    func setupOtherMessage(){
        readL.isHidden = true
        containerV.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1)
        textL.textColor = .black
        leadingC.priority = UILayoutPriority(rawValue: 1000)
        trailingC.priority = UILayoutPriority(rawValue: 250)
    }

}

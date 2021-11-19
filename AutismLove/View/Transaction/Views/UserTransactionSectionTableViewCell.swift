//
//  UserTransactionSectionTableViewCell.swift
//  AutismLove
//
//  Created by BobbyPhtr on 08/06/21.
//

import UIKit

class UserTransactionSectionTableViewCell: UITableViewCell {
    
    static let mReuseIdentifier = "UserSectionCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dropdownImage: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    
    var model : TransactionUserSection! {
        didSet {
            configureView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func configureView(){
        if model.isExpanded ?? false {
            dropdownImage.image = UIImage.init(named: "ic_expanded")!
        } else {
            dropdownImage.image = UIImage.init(named: "ic_collapsed")!
        }
        
        titleLabel.text = model.volunteerData?.name
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .PRIMARY_DARK
        
        separatorView.backgroundColor = .BACKGROUND_LIGHT_GRAY
        
    }
    
}

//
//  MessagingTableViewCell.swift
//  AutismLove
//
//  Created by Samuel Krisna on 29/04/21.
//

import UIKit

class MessagingTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var unreadLabel: UILabel!
    
    @IBOutlet weak var unreadBackground: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        unreadLabel.isHidden = true
//        unreadBackground.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with model: Conversation) {
        
    }
}

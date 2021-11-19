//
//  PublicNotificationTableViewCell.swift
//  AutismLove
//
//  Created by Samuel Krisna on 25/04/21.
//

import UIKit

class PublicNotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView() {
        containerView.shadowAndRoundCorner()
    }
    
    func setupData(with data: AnnouncementData ) {
        contentLabel.text = data.content
    }
    
}

//
//  NotificationTableViewCell.swift
//  AutismLove
//
//  Created by Samuel Krisna on 25/04/21.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }
    
    func setupView() {
        containerView.shadowAndRoundCorner()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(with data: NotificationData) {
        contentLabel.text = data.content
    }
}

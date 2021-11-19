//
//  VASAGrantRequestTableViewCell.swift
//  AutismLove
//
//  Created by Samuel Krisna on 17/05/21.
//

import UIKit

class VASAGrantRequestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var bankAccountNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView() {
        contentView.backgroundColor = .BACKGROUND_LIGHT_GRAY
        containerView.shadowAndRoundCorner()
    }
    
    func setupData(with data: ConnectedUser) {
        usernameLabel.text = data.name
        bankNameLabel.text = data.bank_name
        bankAccountNumberLabel.text = data.bank_account_number
    }
}

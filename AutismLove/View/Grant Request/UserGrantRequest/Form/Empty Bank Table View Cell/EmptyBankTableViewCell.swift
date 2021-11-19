//
//  EmptyBankTableViewCell.swift
//  AutismLove
//
//  Created by Samuel Krisna on 27/04/21.
//

import UIKit

class EmptyBankTableViewCell: UITableViewCell {

    @IBOutlet weak var addButton: DefaultButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupView() {
        backgroundColor = Color.BACKGROUND_LIGHT_GRAY
        
        addButton.linkStyle()
        addButton.shadowAndRoundCorner()
    }
}

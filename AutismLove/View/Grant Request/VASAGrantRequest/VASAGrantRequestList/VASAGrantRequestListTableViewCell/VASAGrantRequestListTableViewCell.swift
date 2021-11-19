//
//  VASAGrantRequestListTableViewCell.swift
//  AutismLove
//
//  Created by Samuel Krisna on 17/05/21.
//

import UIKit

class VASAGrantRequestListTableViewCell: UITableViewCell {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var statusView: UIView!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupView() {
        outerView.backgroundColor = .BACKGROUND_LIGHT_GRAY
        containerView.shadowAndRoundCorner()
        statusView.roundCorners(radius: 7)
    }
    
    func setupData(with data: GrantRequestData) {
        date.text = data.grantDate
        
        if let status = data.status {
            switch status {
            case "ACCEPT":
                statusLabel.text = Strings.Proof_Completed
                statusLabel.textColor = .SECONDARY_MEDIUM_BLUE
                statusView.layer.borderWidth = 1
                statusView.layer.borderColor = UIColor.SECONDARY_MEDIUM_BLUE.cgColor
                statusView.backgroundColor = .white
            case "REJECT":
                statusLabel.text = Strings.Proof_Completed
                statusLabel.textColor = .white
                statusView.backgroundColor = .SECONDARY_MEDIUM_BLUE
            default:
                statusLabel.text = Strings.Upload_Proof
                statusLabel.textColor = .white
                statusView.backgroundColor = .SECONDARY_MEDIUM_BLUE
            }
        }
    }
}

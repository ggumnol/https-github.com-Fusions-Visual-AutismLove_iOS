//
//  MyUserTableViewCell.swift
//  AutismLove
//
//  Created by Samuel Krisna on 30/04/21.
//

import UIKit
import RxSwift

class MyUserTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var accountInfoLabel: UILabel!
    @IBOutlet weak var contractPeriodLabel: UILabel!
    @IBOutlet weak var contractPeriodTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupView() {
        contentView.backgroundColor = UIColor.PRIMARY_DARK
        
        contractPeriodTitleLabel.text = Strings.Contract_Period_
        
        containerView.roundCorners(radius: 7)
    }
    
    func setupData(with viewModel: AssignedUserData) {
        usernameLabel.text = viewModel.name
        if let bankName = viewModel.bankName, let accountNumber = viewModel.bankAccountNumber {
            accountInfoLabel.text = "\(bankName) \(accountNumber)"
        }
        if let start = viewModel.contractPeriodStart, let end = viewModel.contractPeriodEnd {
            contractPeriodLabel.text = "\(start) - \(end)"
        }
    }
}

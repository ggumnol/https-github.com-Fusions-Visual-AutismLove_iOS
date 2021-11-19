//
//  TransactionTableViewCell.swift
//  AutismLove
//
//  Created by BobbyPhtr on 13/05/21.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var remainingBalanceLabel: UILabel!
    
    var viewModel : Transaction! {
        didSet {
            configureView()
        }
    }
    
    static let mReuseIdentifier = "TransactionCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        configureView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    private func configureView(){
        timeLabel.text = viewModel.transDate
        titleLabel.text = viewModel.user.name
        
        if viewModel.withdrawAmount != nil {
            amountLabel.text =  "- \(viewModel.withdrawAmount!)" + " 원"
            amountLabel.textColor = .LIGHT_RED
        } else {
            amountLabel.text = "\(viewModel.depositAmount!)" + " 원"
            amountLabel.textColor = .green
        }
        remainingBalanceLabel.text = "\(viewModel.lastBalance)" + " 원"
        remainingBalanceLabel.textColor = .lightGray
    }
    
}

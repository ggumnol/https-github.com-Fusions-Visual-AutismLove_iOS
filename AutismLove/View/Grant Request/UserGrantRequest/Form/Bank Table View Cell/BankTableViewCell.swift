//
//  BankTableViewCell.swift
//  AutismLove
//
//  Created by Samuel Krisna on 26/04/21.
//

import UIKit
import RxSwift
import RxCocoa

class BankTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var deleteUsageButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
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
        
        containerView.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        containerView.shadowAndRoundCorner()
    }
    
    func setupData(usage: Usage) {
        recipientLabel.text = usage.recipient_name
        
        if usage.bank_name != nil {
            bankLabel.text = "우리은행"
        }
        
        bankLabel.text = usage.bank_name
        accountLabel.text = usage.bank_account_number
        
        if let amount: Int = usage.amount {
            amountLabel.text = "(" + String(amount.withSeparator(separator: ",")) + " 원)"
        }
    }
    
    func setupData(viewModel: GrantRequestViewModel) {
        let data = viewModel
        recipientLabel.text = data.recipientNameObservable.value
        
        if data.bankNameObservable.value != nil {
            bankLabel.text = "우리은행"
        }
        
        accountLabel.text = data.bankAccountNumberObservable.value
        
        if let amount: Int = data.amountObservable.value {
            amountLabel.text = "(" + String(amount.withSeparator(separator: ",")) + " 원)"
        }
    }
}

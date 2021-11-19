//
//  UserTransactionTableViewCell.swift
//  AutismLove
//
//  Created by BobbyPhtr on 13/05/21.
//

import UIKit

class UserTransactionTableViewCell: UITableViewCell {
    
    var viewModel : TransactionUserListModel? {
        didSet {
            configureData()
        }
    }
    
    static let mReuseIdentifier = "UserTransactionCell"

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var idUserLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var nextButton: DefaultButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        configureView()
        configureData()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func configureView(){
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 26)
        usernameLabel.textColor = .PRIMARY_DARK
        
        idUserLabel.textColor = .PRIMARY_DARK
        
        moneyLabel.textColor = .black
        moneyLabel.font = UIFont.boldSystemFont(ofSize: 36)
        
        cellView.backgroundColor = .white
        cellView.shadowAndRoundCorner()
        cellView.layer.borderColor = UIColor.SECONDARY_LIGHT_BLUE.cgColor
        cellView.layer.borderWidth = 1.5
        
        nextButton.tintColor = .PRIMARY_DARK
    }
    
    private func configureData(){
        usernameLabel.text = viewModel?.username
        idUserLabel.text = viewModel?.subtitle
        moneyLabel.text = viewModel?.balanceString
    }
    
}

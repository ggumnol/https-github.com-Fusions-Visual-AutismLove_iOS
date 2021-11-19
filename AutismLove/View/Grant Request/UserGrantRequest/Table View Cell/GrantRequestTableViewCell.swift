//
//  GrantRequestTableViewCell.swift
//  AutismLove
//
//  Created by Samuel Krisna on 25/04/21.
//

import UIKit

class GrantRequestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var uploadProofsView: UIView!
    @IBOutlet weak var uploadProofsLabel: UILabel!
    @IBOutlet weak var uploadProofButton: UIButton!
    @IBOutlet weak var requestReasonTitleLabel: UILabel!
    @IBOutlet weak var requestReasonLabel: UILabel!
    @IBOutlet weak var usageLabel: UILabel!
    @IBOutlet weak var usageTitleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountTitleLabel: UILabel!
    @IBOutlet weak var grantDateLabel: UILabel!
    @IBOutlet weak var grantDateTitleLabel: UILabel!
    @IBOutlet weak var requesterLabel: UILabel!
    @IBOutlet weak var requesterTitleLabel: UILabel!
    @IBOutlet weak var newView: UIView!
    @IBOutlet weak var newLabel: UILabel!
    @IBOutlet weak var rejectedReasonLabel: UILabel!
    @IBOutlet weak var rejectedReasonTitleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusTitleLabel: UILabel!
    
    var no: Int = 0
    var viewModel: GrantRequestViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupView() {
        contentView.backgroundColor = UIColor.BACKGROUND_LIGHT_GRAY
        
        containerView.backgroundColor = .white
        containerView.shadowAndRoundCorner()
        
        uploadProofsView.roundCorners(radius: 8)
        
        requestReasonTitleLabel.text = Strings.Request_Reason_Title
        usageTitleLabel.text = Strings.Usage_Title
        amountTitleLabel.text = Strings.Amount_Title
        grantDateTitleLabel.text = Strings.Grant_Date_Title
        requesterTitleLabel.text = Strings.Requester_Title
        statusTitleLabel.text = Strings.Status_Title
        rejectedReasonTitleLabel.text = Strings.Reason_For_Rejection + " :"
    }
    
    func setupData(with data: GrantRequestData, viewModel: GrantRequestViewModel) {
        self.viewModel = viewModel
        
        newView.roundCorners(radius: 7)
        newLabel.textColor = .white
        if data.accepted_by!.count == 0 || data.rejected_by.count == 0 {
            newView.backgroundColor = .LIGHT_RED
            newLabel.text = Strings.New
        } else {
            newView.backgroundColor = .white
            newLabel.text = ""
        }
        
        if let status = data.status {
            switch status {
            case "ACCEPT":
                statusLabel.text = Strings.GrantRequestStatus.ACCEPT
            case "REJECT":
                statusLabel.text = Strings.GrantRequestStatus.REJECT
            case "MONEY_TRANSFERED":
                statusLabel.text = Strings.GrantRequestStatus.MONEY_TRANSFERED
            default:
                statusLabel.text = Strings.GrantRequestStatus.WAITING
            }
        }
        
        if Globals.userData?.role == "USER" {
            if data.requester?.role == "VOLUNTEER" || data.requester?.role == "SUPPORT_AGENT" {
                uploadProofsLabel.isHidden = true
                uploadProofsView.isHidden = true
            } else {
                uploadProofsLabel.isHidden = false
                uploadProofsView.isHidden = false
            }
        } else if Globals.userData?.role == "VOLUNTEER" {
            if data.requester?.role == "SUPPORT_AGENT" {
                uploadProofsLabel.isHidden = true
                uploadProofsView.isHidden = true
            } else {
                uploadProofsLabel.isHidden = false
                uploadProofsView.isHidden = false
            }
        } else {
            if data.requester?.role == "VOLUNTEER" {
                uploadProofsLabel.isHidden = true
                uploadProofsView.isHidden = true
            } else {
                uploadProofsLabel.isHidden = false
                uploadProofsView.isHidden = false
            }
        }
        
        if data.imagesOfProof!.isEmpty {
            uploadProofsLabel.text = Strings.Upload_Proof
            uploadProofsLabel.textColor = .SECONDARY_MEDIUM_BLUE
            uploadProofsView.backgroundColor = .white
            uploadProofsView.layer.borderWidth = 1
            uploadProofsView.layer.borderColor = UIColor.SECONDARY_MEDIUM_BLUE.cgColor
        } else {
            uploadProofsLabel.text = Strings.Proof_Completed
            uploadProofsLabel.textColor = .white
            uploadProofsView.backgroundColor = .SECONDARY_MEDIUM_BLUE
        }
        
        dateLabel.text = "\(no). \(data.grantDate!)"
        requestReasonLabel.text = data.requestReason
        if data.usages.count != 0 {
            let usages = data.usages
            var bankName:[String] = []
            var recipientName:[String] = []
            var amount:[String] = []
            
            for usage in usages {
                bankName.append((usage?.bank_name)!)
                recipientName.append((usage?.recipient_name)!)
                amount.append(String((usage?.amount)!) + " 원")
            }
            
            usageLabel.text = bankName.joined(separator: ",")
            amountLabel.text = amount.joined(separator: ",")
        }
        grantDateLabel.text = data.grantDate
        requesterLabel.text = data.requester?.name
        
        if data.rejected_by.count > 0 {
            rejectedReasonLabel.isHidden = false
            rejectedReasonTitleLabel.isHidden = false
            if let name = data.rejected_by[0]?.user?.name, let reason = data.rejected_by[0]?.rejected_reason {
                rejectedReasonLabel.text = "\(name) - \(reason)"
            }
        } else {
            rejectedReasonLabel.isHidden = true
            rejectedReasonTitleLabel.isHidden = true
        }
    }
}

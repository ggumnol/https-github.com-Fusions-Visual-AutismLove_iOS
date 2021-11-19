//
//  ShowInfoPopUp.swift
//  AutismLove
//
//  Created by BobbyPhtr on 08/05/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

typealias InfoPopUpModel = ShowInfoPopUp.InfoPopup

class ShowInfoPopUp: UIViewController {
    
    struct InfoPopup {
        let name : String?
        let supportAgency : String?
        let id : String?
        let birthdate : String?
        let contactInfo : String?
    }

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var infoTitleLabel: UILabel!
    @IBOutlet weak var closeButton: DefaultButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var supportAgencyLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var contactInfoLabel: UILabel!
    
    @IBOutlet weak var nameValueLabel: UILabel!
    @IBOutlet weak var supportAgencyValueLabel: UILabel!
    @IBOutlet weak var idValueLabel: UILabel!
    @IBOutlet weak var birthdateValueLabel: UILabel!
    @IBOutlet weak var contactInfoValueLabel: UILabel!
    
    @IBOutlet weak var supportAgencyView: UIView!
    @IBOutlet weak var idView: UIView!
    @IBOutlet weak var birthdateView: UIView!
    
    @IBOutlet weak var messageButton: DefaultButton!
    @IBOutlet weak var callButton: DefaultButton!
    
    let onMessageObservable = PublishSubject<UserType?>.init()
    let onCallObservable = PublishSubject<UserType?>.init()
    
    var infoModel : InfoPopUpModel?
    var userType : UserType?
    
    lazy var labels = [nameLabel, supportAgencyLabel, idLabel, birthdateLabel, contactInfoLabel]
    
    lazy var values = [nameValueLabel, supportAgencyValueLabel, idValueLabel, birthdateValueLabel, contactInfoValueLabel]
    
    convenience init(userType : UserType, model : InfoPopUpModel){
        self.init()
        
        self.userType = userType
        self.infoModel = model
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureData()
    }
    
    private func configureViews(){
        // buttons
        closeButton.tintColor = .PRIMARY_DARK
        messageButton.primaryBlueStyle()
        messageButton.setTitle(Strings.Message, for: .normal)
        callButton.primaryBlueStyle()
        callButton.setTitle(Strings.Call, for: .normal)
        
        // labels
        labels.forEach {
            $0?.font = UIFont.boldSystemFont(ofSize: 14)
            $0?.textColor = .SECONDARY_MEDIUM_BLUE
        }
        
        values.forEach {
            $0?.textColor = .lightGray
            $0?.font = UIFont.systemFont(ofSize: 12)
        }
        
        // Background
        backgroundView.layer.cornerRadius = 8
        backgroundView.layer.shadowRadius = 2
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        backgroundView.layer.shadowOpacity = 0.4
        
        // strings
        idLabel.text = Strings.ID
        nameLabel.text = Strings.Name
        birthdateLabel.text = Strings.Birthdate
        contactInfoLabel.text = Strings.Contact_Info
        supportAgencyLabel.text = Strings.Support_Agency
        
    }
    
    private func configureData(){
        guard let model = infoModel, let type = userType else {return}
        
        switch type {
        case .supportAgency:
            infoTitleLabel.text = Strings.My_Manager_Info
            idView.isHidden = true
            birthdateView.isHidden = true
        case .volunteer:
            infoTitleLabel.text = Strings.My_Volunteer_Info
            supportAgencyView.isHidden = true
        default:
            break
        }
        
        nameValueLabel.text = model.name
        supportAgencyValueLabel.text = model.supportAgency
        idValueLabel.text = model.id
        birthdateValueLabel.text = model.birthdate
        contactInfoValueLabel.text = model.contactInfo
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        switch sender {
        case messageButton:
            onMessageObservable.onNext(userType)
            break
        case callButton:
            onCallObservable.onNext(userType)
            break
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

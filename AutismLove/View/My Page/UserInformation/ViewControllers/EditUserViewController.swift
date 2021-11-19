//
//  EditUserViewController.swift
//  AutismLove
//
//  Created by BobbyPhtr on 08/05/21.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class EditUserViewController: BaseViewController {
    
    var viewModel : UserInformationViewModel!
    private let disposeBag = DisposeBag()
    
    // Labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var contactInfoLabel: UILabel!
    @IBOutlet weak var accountInfoLabel: UILabel!
    @IBOutlet weak var contractPeriodStartLabel: UILabel!
    @IBOutlet weak var contractPeriodEndLabel: UILabel!
    
    @IBOutlet weak var birthdateFieldLabel: UILabel!
    @IBOutlet weak var supportAgencyFieldLabel: UILabel!
    @IBOutlet weak var jobTitleFieldLabel: UILabel!
    
    @IBOutlet weak var contactInfoField: UITextField!
    // Volunteer Only
    @IBOutlet weak var birthdateField: UITextField!
    // Support Agency Only
    @IBOutlet weak var supportAgencyField: UITextField!
    // Support Agency Only
    @IBOutlet weak var jobTitleField: UITextField!
    
    // Views
    @IBOutlet weak var jobTitleFieldView: UIView!
    @IBOutlet weak var supportAgencyFieldView: UIView!
    @IBOutlet weak var birthdateFieldView: UIView!
    @IBOutlet weak var birthdateView: UIView!
    @IBOutlet weak var accountInfoView: UIView!
    @IBOutlet weak var contractPeriodStartView: UIView!
    @IBOutlet weak var contractPeriodEndView: UIView!
    
    // Value Labels
    @IBOutlet weak var idValueLabel: UILabel!
    @IBOutlet weak var nameValueLabel: UILabel!
    @IBOutlet weak var birthdateValueLabel: UILabel!
    @IBOutlet weak var accountInfoValueLabel: UILabel!
    @IBOutlet weak var contractPeriodStartValueLabel: UILabel!
    @IBOutlet weak var contractPeriodEndValueLabel: UILabel!
    
    @IBOutlet weak var saveButton: DefaultButton!
    
    private let datePicker = UIDatePicker()

    convenience init(viewModel : UserInformationViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    private lazy var titleLabels = [nameLabel, idLabel, birthdateLabel, contactInfoLabel, accountInfoLabel, contractPeriodStartLabel, birthdateFieldLabel, supportAgencyFieldLabel, jobTitleFieldLabel, contractPeriodEndLabel]
    
    private lazy var valueLabels = [idValueLabel, nameValueLabel, birthdateValueLabel, accountInfoValueLabel, contractPeriodStartValueLabel, contractPeriodEndValueLabel]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = Strings.User_Information
        
        configureViews()
        configureData()
        configureBindings()
    }
    
    // MARK: CONFIGURE VIEWS
    private func configureViews(){
        idLabel.text = Strings.ID
        nameLabel.text = Strings.Name
        birthdateLabel.text = Strings.Birthdate
        contactInfoLabel.text = Strings.Contact_Info
        accountInfoLabel.text = Strings.Account_Info
        contractPeriodStartLabel.text = Strings.Contract_Period
        contractPeriodEndLabel.text = Strings.Contract_Period
        
        // Title labels
        titleLabels.forEach {
            $0?.font = UIFont.boldSystemFont(ofSize: 20)
            $0?.textColor = .SECONDARY_MEDIUM_BLUE
        }
        
        // Value labels
        valueLabels.forEach {
            $0?.textColor = .lightGray
            $0?.font = UIFont.systemFont(ofSize: 16)
        }
        
        saveButton.primaryBlueStyle()
        
        contactInfoField.keyboardType = .phonePad
        
        addDatePicker()
    }
    
    // MARK: CONFIGURE DATA
    private func configureData(){
        switch viewModel.userData?.getUserType {
        case .user:
            nameValueLabel.text = viewModel.userData?.name
            idValueLabel.text = viewModel.userData?.email
            birthdateValueLabel.text = viewModel.userData?.birthdate
            contactInfoField.text = viewModel.userData?.phoneNumber
            accountInfoValueLabel.text = "\(viewModel.userData?.bankName ?? "") \(viewModel.userData?.bankAccountNumber ?? "")"
            contractPeriodStartValueLabel.text = viewModel.userData?.contractPeriodStart
            contractPeriodEndValueLabel.text = viewModel.userData?.contractPeriodEnd
            
            supportAgencyFieldView.isHidden = true
            jobTitleFieldView.isHidden = true
            birthdateFieldView.isHidden = true
            break
        case .supportAgency:
            nameValueLabel.text = viewModel.userData?.name
            idValueLabel.text = viewModel.userData?.id
            contactInfoField.text = viewModel.userData?.phoneNumber
            supportAgencyField.text = viewModel.userData?.supportAgency
            jobTitleField.text = viewModel.userData?.jobTitle
            
            birthdateView.isHidden = true
            birthdateFieldView.isHidden = true
            accountInfoView.isHidden = true
            contractPeriodStartView.isHidden = true
            contractPeriodEndView.isHidden = true
            break
        case .volunteer:
            nameValueLabel.text = viewModel.userData?.name
            idValueLabel.text = viewModel.userData?.email
            birthdateField.text = viewModel.userData?.birthdate
            contactInfoField.text = viewModel.userData?.phoneNumber
            
            accountInfoView.isHidden = true
            contractPeriodStartView.isHidden = true
            contractPeriodEndView.isHidden = true
            supportAgencyFieldView.isHidden = true
            jobTitleFieldView.isHidden = true
            birthdateView.isHidden = true
            break
        default:
            break
        }
    }
    
    // MARK: CONFIGURE BINDINGS
    private func configureBindings(){
        saveButton.rx.tap
            .bind { [unowned self] in
                SVProgressHUD.show(withStatus: Strings.Loading)
                self.viewModel.saveEdittedProfile()
                    .subscribe(onNext: { response in
                        SVProgressHUD.dismiss()
                        if response.success == true{
                            Globals.userData = response.data?.user
                            viewModel.refreshUserData()
                            self.showDefaultDialog(message: response.message!) {
                                navigationController?.popViewController(animated: true)
                            }
                        } else {
                            self.showDefaultDialog(message: response.message!, onOkAction: nil)
                        }
                    }) { err in
                        SVProgressHUD.dismiss()
                        self.showDefaultDialog(message: err.localizedDescription, onOkAction: nil)
                    }
                    .disposed(by: disposeBag)
            }.disposed(by: disposeBag)
        
        birthdateField.rx.text
            .bind(to: viewModel.birthdateObservable)
            .disposed(by: disposeBag)
        
        supportAgencyField.rx.text
            .bind(to: viewModel.supportAgencyObservable)
            .disposed(by: disposeBag)
        
        jobTitleField.rx.text
            .bind(to: viewModel.jobTitleObservable)
            .disposed(by: disposeBag)
        
        contactInfoField.rx.text
            .bind(to: viewModel.phoneNumObservable)
            .disposed(by: disposeBag)
    }

    

}

extension EditUserViewController {
    
    func addDatePicker(){
        datePicker.datePickerMode = .date
        datePicker.locale = .EN
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        datePicker.setDate(dateFormatter.date(from: viewModel.userData!.birthdate!)!, animated: false)
        
        let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
         doneButton.setTitleTextAttributes([.foregroundColor : UIColor.PRIMARY_DARK], for: .normal)
          let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        cancelButton.setTitleTextAttributes([.foregroundColor : UIColor.PRIMARY_DARK], for: .normal)

        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        birthdateField.inputAccessoryView = toolbar
        birthdateField.inputView = datePicker
    }
    
    @objc func donedatePicker(){
       let formatter = DateFormatter()
       formatter.dateFormat = "yyyy-MM-dd"
       birthdateField.text = formatter.string(from: datePicker.date)
       self.view.endEditing(true)
     }

     @objc func cancelDatePicker(){
        self.view.endEditing(true)
      }
}

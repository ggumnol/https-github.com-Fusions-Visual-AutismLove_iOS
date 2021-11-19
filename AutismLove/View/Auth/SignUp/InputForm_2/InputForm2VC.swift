//
//  SignUpChooseUserType.swift
//  AutismLove
//
//  Created by BobbyPhtr on 26/04/21.
//

import UIKit
import M13Checkbox
import RxSwift
import RxCocoa
import SVProgressHUD

class InputForm2VC : BaseViewController, UITextFieldDelegate {
    
    var viewModel : SignUpViewModel!
    private let disposeBag = DisposeBag()
    
    private var datePicker = UIDatePicker()
    private var toolBar = UIToolbar()
    
    @IBOutlet weak var nameField: CustomTextField!
    @IBOutlet weak var birthdateField: CustomTextField!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var contactNumberField: CustomTextField!
    @IBOutlet weak var jobTitleField: CustomTextField!
    @IBOutlet weak var supportAgencyField: CustomTextField!
    
    @IBOutlet weak var signUpTitle: UILabel!
    @IBOutlet weak var signUpSubtitle: UILabel!
    
    @IBOutlet weak var finishButton: DefaultButton!
    
    convenience init(viewModel : SignUpViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureBindings()
        configureData()
    }
    
    private func configureViews() {
        signUpTitle.text = Strings.Sign_Up
        signUpTitle.textColor = .PRIMARY_DARK
        
        nameField.setFloatingLabel(Strings.Name)
        
        contactNumberField.setFloatingLabel(Strings.Contact_Number)
        contactNumberField.keyboardType = .phonePad
        contactNumberField.placeholder = Strings.Phone_Placeholder
        
        dateButton.tintColor = Color.SECONDARY_MEDIUM_BLUE
        birthdateField.delegate = self
        birthdateField.keyboardType = .numberPad
        switch viewModel?.currentUserTypeObservable.value {
        case .user, .volunteer:
            birthdateField.setFloatingLabel(Strings.Birthdate)
            birthdateField.placeholder = Strings.Birthdate_Placeholder
//            addDatePicker()
            jobTitleField.isHidden = true
            supportAgencyField.isHidden = true
        case .supportAgency:
            birthdateField.isHidden = true
            jobTitleField.setFloatingLabel(Strings.Job_Title)
            supportAgencyField
                .setFloatingLabel(Strings.Support_Agency)
        default:
            break
        }
        
        finishButton.primaryBlueStyle()
        finishButton.setTitle(Strings.Finish, for: .normal)
    }
    
    private func configureBindings(){
        finishButton.rx.tap
            .bind { [unowned self] in
                validate()
            }.disposed(by: disposeBag)
        
        nameField.rx.text
            .bind(to: viewModel.nameObsevable)
            .disposed(by: disposeBag)
        
        birthdateField.rx.text
            .bind(to: viewModel.birthdateObservable)
            .disposed(by: disposeBag)
        
        contactNumberField.rx.text
            .bind(to: viewModel.contactNumberObservable)
            .disposed(by: disposeBag)
        
        jobTitleField.rx.text
            .bind(to: viewModel.jobTitleObservable)
            .disposed(by: disposeBag)
        
        supportAgencyField.rx.text
            .bind(to: viewModel.supportAgencyObservable)
            .disposed(by: disposeBag)
    }
    
    private func configureData(){
        switch viewModel?.currentUserTypeObservable.value {
        case .user:
            signUpSubtitle.text = Strings.Input_User_Information
            break
        case .volunteer:
            signUpSubtitle.text = Strings.Input_Volunteer_Information
            break
        case .supportAgency:
            signUpSubtitle.text = Strings.Input_Support_Agent_Information
            break
        default:
            break
        }
    }
    
    private func validate(){
        viewModel?.validateSecondForm()
            .subscribe { [unowned self] (isSuccess) in
                if isSuccess == true {
                    SVProgressHUD.show(withStatus: Strings.Registering)
                    self.viewModel.doRegistration()
                        .subscribe(onNext: { [weak self] response in
                            SVProgressHUD.dismiss()
                            if response.success == true {
                                self?.showDefaultDialog(message: response.message!, onOkAction: {
                                    self?.navigationController?.popToRootViewController(animated: true)
                                })
                            } else {
                                self?.showDefaultDialog(message: response.message!, onOkAction: nil)
                            }
                        }).disposed(by: disposeBag)
                }
            } onFailure: { (error) in
                self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
            }
            .disposed(by: disposeBag)
        
    }
    
    @IBAction func dateButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        onDoneButtonClick()
        
        datePicker = UIDatePicker.init()
        datePicker.backgroundColor = UIColor.white
        
        datePicker.autoresizingMask = .flexibleWidth
        datePicker.datePickerMode = .date
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
        datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(datePicker)
        
        toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .black
        toolBar.items = [UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonClick))]
        toolBar.sizeToFit()
        self.view.addSubview(toolBar)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == birthdateField {
            // check the chars length dd -->2 at the same time calculate the dd-MM --> 5
            if (birthdateField?.text?.count == 4) || (birthdateField?.text?.count == 7) {
                //Handle backspace being pressed
                if !(string == "") {
                    // append the text
                    birthdateField?.text = (birthdateField?.text)! + "-"
                }
            }
            // check the condition not exceed 9 chars
            return !(textField.text!.count > 9 && (string.count ) > range.length)
        } else {
            return true
        }
    }
}

extension InputForm2VC {
    @objc func dateChanged(_ sender: UIDatePicker?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = sender?.date {
            let dateString = dateFormatter.string(from: date)
            birthdateField.text = dateString
        }
    }

    @objc func onDoneButtonClick() {
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
    }
    
    func addDatePicker(){
        datePicker.datePickerMode = .date
        datePicker.locale = .EN
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
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

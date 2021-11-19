//
//  AddEditUsageViewController.swift
//  AutismLove
//
//  Created by Samuel Krisna on 26/04/21.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD
import DLRadioButton

class AddEditUsageViewController: BaseViewController {
    
    @IBOutlet weak var userInputLabel: UILabel!
    @IBOutlet weak var userInputTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recipientTitleLabel: UILabel!
    @IBOutlet weak var recipientTextfField: UITextField!
    @IBOutlet weak var bankNameTitleLabel: UILabel!
    @IBOutlet weak var bankNameTextField: UITextField!
    @IBOutlet weak var accountNumberTitleLabel: UILabel!
    @IBOutlet weak var accountNumberTextField: UITextField!
    @IBOutlet weak var requestAmountTitleLabel: UILabel!
    @IBOutlet weak var requestAmountTextField: UITextField!
    @IBOutlet weak var wonLabel: UILabel!
    
    @IBOutlet weak var radioButton1: DLRadioButton!
    @IBOutlet weak var radioButton2: DLRadioButton!
    
    @IBOutlet weak var confirmButton: DefaultButton!
    
    var viewModel: GrantRequestViewModel!
    private let disposeBag = DisposeBag()
    
    var radioButtonValue:String!
    let recipientPicker = UIPickerView()
    let bankPicker = UIPickerView()
    let toolBar = UIToolbar()
    
    convenience init(viewModel: GrantRequestViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupPicker()
        setupData()
        setupBindings()
    }
    
    private func setupView() {
        navigationTitleLogoImage()
        titleLabel.text = Strings.AddEditUsageStrings.Add_Edit_Usage_Title
        recipientTitleLabel.text = Strings.AddEditUsageStrings.Recipient
        userInputLabel.text = Strings.AddEditUsageStrings.User_Input
        bankNameTitleLabel.text = Strings.AddEditUsageStrings.Bank_Name
        accountNumberTitleLabel.text = Strings.AddEditUsageStrings.Account_Number
        requestAmountTitleLabel.text = Strings.AddEditUsageStrings.Request_Amount
        wonLabel.text = Strings.Won
        
        radioButton1.isSelected = true
        
        radioButton1.setTitle(Strings.AddEditUsageStrings.Send_To_Other, for: .normal)
        if Globals.userData?.role == "USER" {
            radioButton2.setTitle(Strings.AddEditUsageStrings.Send_To_Me, for: .normal)
        } else {
            radioButton2.setTitle(Strings.AddEditUsageStrings.Send_To_User, for: .normal)
        }
        
        recipientTextfField.shadowAndRoundCorner()
        userInputTextField.shadowAndRoundCorner()
        bankNameTextField.shadowAndRoundCorner()
        accountNumberTextField.shadowAndRoundCorner()
        requestAmountTextField.shadowAndRoundCorner()
        
        confirmButton.setTitle(Strings.Confirm, for: .normal)
        confirmButton.primaryBlueStyle()
        
        userInputLabel.isHidden = true
        userInputTextField.isHidden = true
    }
    
    private func setupData() {
        SVProgressHUD.show()
        
        Observable.of(viewModel.getConnectedUser(), viewModel.getAllBank()).merge().subscribe(onError: { e in
            SVProgressHUD.dismiss()
            self.showDefaultDialog(message: "\(e.localizedDescription)", onOkAction: nil)
        }, onCompleted: {
            SVProgressHUD.dismiss()
        })
        .disposed(by: disposeBag)
    }
    
    private func setupBindings() {
        recipientTextfField.rx.text
            .bind(to: viewModel.recipientNameObservable)
            .disposed(by: disposeBag)
        
        bankNameTextField.rx.text
            .bind(to: viewModel.bankNameObservable)
            .disposed(by: disposeBag)
        
        userInputTextField.rx.text
            .bind(to: viewModel.bankNameObservable)
            .disposed(by: disposeBag)
        
        accountNumberTextField.rx.text
            .bind(to: viewModel.bankAccountNumberObservable)
            .disposed(by: disposeBag)
        
        requestAmountTextField.rx.text.map {
            return Int($0!)
        }.bind(to: viewModel.amountObservable).disposed(by: disposeBag)
                
        confirmButton.rx.tap.bind { [unowned self] in
            print("Confirm button tapped")
            validateUsageInput()
        }.disposed(by: disposeBag)
    }
    
    private func setupPicker() {
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton,doneButton], animated: false)
        
        bankPicker.delegate = self
        bankNameTextField.inputView = bankPicker
        bankNameTextField.inputAccessoryView = toolBar
    }
    
    func validateUsageInput() {
        viewModel.validateUsageInput().subscribe { [unowned self] isSuccess in
            if isSuccess == true {
                viewModel.isUsageFilledObservable.accept(true)
                viewModel.usagesObservable.append(Usage(amount: viewModel.amountObservable.value, _id: nil, recipient_name: viewModel.recipientNameObservable.value, bank_name: viewModel.bankNameObservable.value, bank_account_number: viewModel.bankAccountNumberObservable.value))
//                viewModel.usagesObservable.append(Usage(recipient_name: viewModel.recipientNameObservable.value, _id: nil, bank_name: viewModel.bankNameObservable.value, bank_account_number: viewModel.bankAccountNumberObservable.value, amount: viewModel.amountObservable.value))
                resetUsageObservable()
                self.navigationController?.popViewController(animated: true)
            }
        } onFailure: { error in
            self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
        }.disposed(by: disposeBag)
    }
    
    func resetUsageObservable() {
        viewModel.recipientNameObservable.accept(nil)
        viewModel.bankNameObservable.accept(nil)
        viewModel.bankAccountNumberObservable.accept(nil)
        viewModel.amountObservable.accept(nil)
    }
    
    @objc @IBAction fileprivate func logSelectedRadioButton(_ radioButton: DLRadioButton) {
        radioButtonValue = radioButton.selected()?.titleLabel?.text
        print(String(format: "%@ is selected", radioButtonValue))
        
        if radioButton.selected() == radioButton1 {
            recipientTextfField.isEnabled = true
            bankNameTextField.isEnabled = true
            accountNumberTextField.isEnabled = true
            
            recipientTextfField.backgroundColor = .white
            bankNameTextField.backgroundColor = .white
            accountNumberTextField.backgroundColor = .white
            
            recipientTextfField.text = ""
            bankNameTextField.text = ""
            accountNumberTextField.text = ""
        } else {
//            recipientTextfField.isEnabled = false
            bankNameTextField.isEnabled = false
            accountNumberTextField.isEnabled = false
            
//            recipientTextfField.backgroundColor = .systemGray5
            bankNameTextField.backgroundColor = .systemGray5
            accountNumberTextField.backgroundColor = .systemGray5
            
            if Globals.userData?.role == "USER" {
//                recipientTextfField.text = Globals.userData?.name
                bankNameTextField.text = Globals.userData?.bankName
                accountNumberTextField.text = Globals.userData?.bankAccountNumber
            } else {
//                recipientTextfField.text = viewModel.connectedUserData.name
                bankNameTextField.text = viewModel.connectedUserData.bank_name
                accountNumberTextField.text = viewModel.connectedUserData.bank_account_number
            }
            
//            viewModel.recipientNameObservable.accept(recipientTextfField.text)
            viewModel.bankNameObservable.accept(bankNameTextField.text)
            viewModel.bankAccountNumberObservable.accept(accountNumberTextField.text)
        }
    }
}

extension AddEditUsageViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case bankPicker:
            return viewModel.bankList.count
        default:
            return viewModel.recipientList.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case bankPicker:
            let row = viewModel.bankList[row].name
            return row
        default:
            let row = viewModel.recipientList[row].name
            return row
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case bankPicker:
            if !viewModel.bankList.isEmpty {
                let bank = viewModel.bankList[row]
                bankNameTextField.text = bank.name
                
                if row == viewModel.bankList.count-1 {
                    userInputLabel.isHidden = false
                    userInputTextField.isHidden = false
                } else {
                    userInputTextField.text = ""
                    viewModel.bankNameObservable.accept(bank.name)
                    
                    userInputLabel.isHidden = true
                    userInputTextField.isHidden = true
                }
            }
        default:
            if !viewModel.recipientList.isEmpty {
                let recipient = viewModel.recipientList[row]
                
                // Textfield
                recipientTextfField.text = recipient.name
                bankNameTextField.text = recipient.bank_account_name
                accountNumberTextField.text = recipient.bank_account_number
                
                // Accept
                viewModel.recipientNameObservable.accept(recipient.name)
                viewModel.bankNameObservable.accept(recipient.bank_name)
                viewModel.bankAccountNumberObservable.accept(recipient.bank_account_number)
            }
        }
    }
}

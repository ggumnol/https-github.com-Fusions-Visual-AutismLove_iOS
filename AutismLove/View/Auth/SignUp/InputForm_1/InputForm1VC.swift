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

class InputForm1VC : BaseViewController {
    
    var viewModel : SignUpViewModel!
    private let disposeBag = DisposeBag()

    @IBOutlet weak var signUpTitle: UILabel!
    @IBOutlet weak var signUpSubtitle: UILabel!
    
    @IBOutlet weak var idField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    @IBOutlet weak var confirmPasswordField: CustomTextField!
    
    @IBOutlet weak var nextButton: DefaultButton!
    @IBOutlet weak var verifyButton: DefaultButton!
    
    private var isEmailVerified = false
    
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
        signUpTitle.textColor = .PRIMARY_DARK
        
        signUpTitle.text = Strings.Sign_Up
        signUpSubtitle.text = Strings.ID_Password_Input
        idField.setFloatingLabel(Strings.ID)
        idField.keyboardType = .emailAddress
        idField.placeholder = "abc@abc.com"
        
        passwordField.setFloatingLabel(Strings.Password)
        passwordField.isPassword = true
        passwordField.textContentType = .newPassword
        
        confirmPasswordField.setFloatingLabel(Strings.Confirm_Password)
        confirmPasswordField.isPassword = true
        confirmPasswordField.textContentType = .newPassword
        
        verifyButton.secondaryBlueStyle()
        nextButton.setTitle(Strings.Verify, for: .normal)

        nextButton.primaryBlueStyle()
        nextButton.setTitle(Strings.Next, for: .normal)
       
    }
    
    private func configureBindings(){
        nextButton.rx.tap
            .bind { [unowned self] in
                if isEmailVerified {
                    validate()
                } else {
                    self.showDefaultDialog(message: Strings.Please_Verify_Email_First, onOkAction: nil)
                }
               
            }.disposed(by: disposeBag)
        
        verifyButton.rx.tap
            .bind { [unowned self] in
                validateEmail()
            }.disposed(by: disposeBag)
        
        idField.rx.text
            .map {
                self.isEmailVerified = false
                return $0!
            }
            .bind(to: viewModel.idObservable)
            .disposed(by: disposeBag)
        
        passwordField.rx.text
            .bind(to: viewModel.tempPasswordObservable)
            .disposed(by: disposeBag)
        
        confirmPasswordField.rx.text
            .bind(to: viewModel.confirmedPasswordObservable)
            .disposed(by: disposeBag)
        
        viewModel.tempPasswordObservable
            .bind(to: self.passwordField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.confirmedPasswordObservable
            .bind(to: self.confirmPasswordField.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func configureData(){
        switch viewModel.currentUserTypeObservable.value {
        case .user:
            signUpSubtitle.text = Strings.Input_User_Information
            break
        case .supportAgency:
        signUpSubtitle.text = Strings.Input_Support_Agent_Information
        break
        case .volunteer:
        signUpSubtitle.text = Strings.Input_Volunteer_Information
        break
        default:
            break
        }
    }
    
    private func validate(){
        viewModel.validateFirstForm()
            .subscribe { [unowned self] (isSuccess) in
                if isSuccess == true {
                    let vc = InputForm2VC.init(viewModel: self.viewModel)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } onFailure: { (error) in
                self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
            } onDisposed: {
                print("Disposed")
            }
            .disposed(by: disposeBag)

    }
    
    private func validateEmail(){
        viewModel.validateEmail()
            .subscribe { [unowned self] (isSuccess) in
                if isSuccess == true {
                   verifyEmail()
                }
            } onFailure: { (error) in
                self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
            }
            .disposed(by: disposeBag)
    }
    
    private func verifyEmail(){
        SVProgressHUD.show(withStatus: Strings.Verifiying)
        viewModel.doVerifyEmail()
            .subscribe(onNext :{ [unowned self] response in
                SVProgressHUD.dismiss()
                if response.success == true {
                    self.isEmailVerified = true
                    self.showDefaultDialog(message: "사용할 수 있는 아이디 입니다", onOkAction: nil)
                } else {
                    self.isEmailVerified = false
                    self.showDefaultDialog(message: "사용할 수 없는 아이디 입니다", onOkAction: nil)
                }
            }).disposed(by: disposeBag)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

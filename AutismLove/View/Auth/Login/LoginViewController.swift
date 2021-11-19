//
//  LoginViewController.swift
//  AutismLove
//
//  Created by BobbyPhtr on 26/04/21.
//

import UIKit
import M13Checkbox
import RxSwift
import RxCocoa
import SVProgressHUD

class LoginViewController: BaseViewController {
    
    var viewModel : LoginViewModel!
    private let disposeBag = DisposeBag()

    @IBOutlet weak var masterStack: UIStackView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var idTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    @IBOutlet weak var checkBoxView: M13Checkbox!
    @IBOutlet weak var checkBoxButton: DefaultButton!
    
    @IBOutlet weak var loginButton: DefaultButton!
    
    @IBOutlet weak var recoverIdButton: DefaultButton!
    @IBOutlet weak var replacePasswordButton: DefaultButton!
    @IBOutlet weak var signUpButton: DefaultButton!
    
    // logo constraints
    @IBOutlet weak var verticalCenterContraint: NSLayoutConstraint!
    @IBOutlet weak var logoToMasterStackConstraint: NSLayoutConstraint!
    
    private var isAppeared = false
    
    convenience init(viewModel : LoginViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureBindings()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationController()
        if !isAppeared {
            masterStack.alpha = 0.0
        }
        
        viewModel.clearCachedData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isAppeared {
            UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut) { [unowned self] in
                self.verticalCenterContraint.priority = .defaultLow
                self.view.layoutIfNeeded()
            } completion: { [unowned self] (_) in
                UIView.animate(withDuration: 0.3) { [unowned self] in
                    self.masterStack.alpha = 1.0
                }
            }
        }
        isAppeared = true
    }
    
    private func configureView() {
        idTextField.setFloatingLabel(Strings.ID)
        idTextField.keyboardType = .emailAddress
        if let savedId = viewModel.idObservable.value { idTextField.text = savedId }
        
        passwordTextField.setFloatingLabel(Strings.Password)
        passwordTextField.isPassword = true
        
        checkBoxView.markType = .checkmark
        checkBoxView.boxType = .circle
        checkBoxView.tintColor = Color.PRIMARY_DARK
        checkBoxView.secondaryTintColor = Color.DARK_GRAY
        checkBoxView.stateChangeAnimation = .fill
        checkBoxView.addTarget(self, action: #selector(onSavedIdCheckChanged), for: .valueChanged)
        
        checkBoxButton.textStyle()
        checkBoxButton.setTitle(Strings.Remember_Id, for: .normal)
        
        loginButton.primaryBlueStyle()
        loginButton.setTitle(Strings.Login, for: .normal)
        
        recoverIdButton.textStyle()
        recoverIdButton.setTitle(Strings.Recover_Id, for: .normal)
        
        replacePasswordButton.textStyle()
        replacePasswordButton.setTitle(Strings.Replace_Password, for: .normal)
        
        signUpButton.textStyle()
        signUpButton.setTitle(Strings.Sign_Up, for: .normal)
    }
    
    private func configureBindings() {
        checkBoxButton.rx.tap
            .bind{ [unowned self] in
                self.checkBoxView.toggleCheckState()
                onSavedIdCheckChanged()
            }
            .disposed(by: disposeBag)
        
        idTextField.rx.text
            .bind(to: viewModel.idObservable)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .bind(to: viewModel.passwordObservable)
            .disposed(by: disposeBag)
        
        viewModel.isIdSavedObservable
            .map { $0 ? M13Checkbox.CheckState.checked : M13Checkbox.CheckState.unchecked }
            .bind(to: checkBoxView.rx.checkState)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind { [unowned self] in self.doLogin() }
            .disposed(by: disposeBag)
        
    }
    
    private func doLogin(){
        SVProgressHUD.show(withStatus: Strings.Authenticating)
        self.viewModel.doLogin()
            .subscribe(onCompleted: { [unowned self] in
                SVProgressHUD.dismiss()
//                showDefaultDialog(message: Strings.Logged_In, onOkAction: nil)
                let vc = TabBarController.init()
                self.navigationController?.setViewControllers([vc], animated: true)
            }, onError: { e in
                SVProgressHUD.dismiss()
                print("On Error : \(e.localizedDescription)")
                self.showDefaultDialog(message: "\(e.localizedDescription)", onOkAction: nil)
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func onSavedIdCheckChanged(){
        if checkBoxView.checkState == .checked {
            viewModel.isIdSavedObservable.accept(true)
        } else {
            viewModel.isIdSavedObservable.accept(false)
        }
    }
    
    @IBAction func buttonTapped(_ sender: DefaultButton) {
        switch sender {
        case recoverIdButton:
            let verificationVC = AskPhoneNumberViewController.init(viewModel: VerificationViewModel.init(), verificationFlow: .recoverID)
            navigationController?.pushViewController(verificationVC, animated: true)
            break
        case replacePasswordButton:
            let verificationVC = AskIdViewController.init(viewModel: VerificationViewModel.init(), verificationFlow: .replacePassword)
            navigationController?.pushViewController(verificationVC, animated: true)
            break
        case signUpButton:
            let signUpVC = SignUpChooseUserTypeVC.init(viewModel: SignUpViewModel.init())
            self.navigationController?.pushViewController(signUpVC, animated: true)
            break
        default:
            break
        }
    }
}

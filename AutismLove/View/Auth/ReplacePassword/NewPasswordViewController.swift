//
//  NewPasswordViewController.swift
//  AutismLove
//
//  Created by BobbyPhtr on 28/04/21.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class NewPasswordViewController : BaseViewController {
    
    var viewModel : NewPasswordViewModel!
    var userInformationViewModel : UserInformationViewModel!
    private let disposeBag = DisposeBag()

    @IBOutlet weak var backButton: DefaultButton!
    
    @IBOutlet weak var newPasswordTitle: UILabel!
    @IBOutlet weak var newPasswordSubtitle: UILabel!
    
    @IBOutlet weak var passwordField: CustomTextField!
    @IBOutlet weak var confirmPasswordField: CustomTextField!
    
    @IBOutlet weak var confirmReturnToLoginButton: DefaultButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationController()
    }
    
    private func configureView() {
        newPasswordTitle.textColor = .PRIMARY_DARK
        
        newPasswordTitle.text = Strings.New_Password
        newPasswordSubtitle.text = Strings.New_Password_Subtitle
        
        passwordField.setFloatingLabel(Strings.Password)
        passwordField.isPassword = true
        passwordField.textContentType = .newPassword
        
        confirmPasswordField.setFloatingLabel(Strings.Confirm_Password)
        confirmPasswordField.isPassword = true
        confirmPasswordField.textContentType = .newPassword
        
        confirmReturnToLoginButton.setTitle(Strings.Confirm_Return_To_Login, for: .normal)
        confirmReturnToLoginButton.primaryBlueStyle()
    }
    
    private func configureBindings(){
        backButton.rx.tap
            .bind{ [unowned self] in
                self.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        passwordField.rx.text
            .bind(to: viewModel.tempPasswordObservable)
            .disposed(by: disposeBag)
        
        confirmPasswordField.rx.text
            .bind(to: viewModel.confirmedPasswordObservable)
            .disposed(by: disposeBag)
        
        confirmReturnToLoginButton.rx.tap
            .bind {
                self.doProcess()
            }.disposed(by: disposeBag)
            
    }
    
    private func doProcess(){
        SVProgressHUD.show(withStatus: Strings.Loading)
        viewModel.validate()
            .flatMap { _ in return self.viewModel.submitNewPassword() }
            .subscribe(onError: { error in
                SVProgressHUD.dismiss()
                self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
            }, onCompleted: {
                SVProgressHUD.dismiss()
                self.showDefaultDialog(message: Strings.Password_Has_Been_Reset) { [self] in
//                    self.navigationController?.popToRootViewController(animated: true)
                    userInformationViewModel.onLogOut().subscribe {
                        SVProgressHUD.dismiss()
                        self.showDefaultDialog(message: Strings.You_Have_Been_LogOut) {
                            let scene = UIApplication.shared.connectedScenes.first
                            if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                                sd.switchToLogin()
                            }
                        }
                    } onError: { err in
                        SVProgressHUD.dismiss()
                        self.showDefaultDialog(message: err.localizedDescription, onOkAction: nil)
                    }
                    .disposed(by: disposeBag)
                }
            })
            .disposed(by: disposeBag)
    }

}

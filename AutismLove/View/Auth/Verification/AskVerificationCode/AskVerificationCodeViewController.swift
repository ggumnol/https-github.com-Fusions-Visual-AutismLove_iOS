//
//  VerificationCodeViewController.swift
//  AutismLove
//
//  Created by BobbyPhtr on 28/04/21.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class AskVerificationCodeViewController: BaseViewController {
    
    var viewModel : VerificationViewModel!
    private let disposeBag = DisposeBag()

    @IBOutlet weak var backButton: DefaultButton!
    
    @IBOutlet weak var recoverIdTitle: UILabel!
    @IBOutlet weak var recoverIdSubtitle: UILabel!
    
    @IBOutlet weak var verificationCodeField: CustomTextField!
    @IBOutlet weak var confirmButton: DefaultButton!
    
    // MARK: PROPERTIES
    var verificationFlowType : VerificationFlow?
    
    convenience init(viewModel : VerificationViewModel, verificationFlow : VerificationFlow) {
        self.init()
        self.viewModel = viewModel
        self.verificationFlowType = verificationFlow
    }
    
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
        recoverIdTitle.textColor = .PRIMARY_DARK
        
        if verificationFlowType == .recoverID{
            recoverIdTitle.text = Strings.Recover_Id
        } else if verificationFlowType == .replacePassword {
            recoverIdTitle.text = Strings.Replace_Password
        }
        
        recoverIdSubtitle.text = Strings.Verification_Subtitle_2
        
        verificationCodeField.setFloatingLabel(Strings.Enter_Verification_Number)
        
        confirmButton.setTitle(Strings.Confirm, for: .normal)
        confirmButton.primaryBlueStyle()
        
        verificationCodeField.keyboardType = .numberPad
        
    }
    
    private func configureBindings(){
        confirmButton.rx.tap
            .bind { [unowned self] in
                self.submitCode()
            }
            .disposed(by: disposeBag)
        
        verificationCodeField.rx.text
            .bind(to: viewModel.verificationNumberObservable)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind {
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func submitCode(){
        SVProgressHUD.show()
        switch verificationFlowType {
        case .recoverID:
            viewModel.verifyToServerForRecoverID()
                .subscribe(onNext: { response in
                    SVProgressHUD.dismiss()
                    if response.success! {
                        let vm = RecoverIDResultViewModel.init()
                        vm.recoveredId.accept(response.data?.user?.email)
                        let vc = RecoverIDResultVC.init(viewModel: vm)
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        self.showDefaultDialog(message: response.message!, onOkAction: nil)
                    }
                }, onError: { (err) in
                    SVProgressHUD.dismiss()
                    self.showDefaultDialog(message: err.localizedDescription, onOkAction: nil)
                }).disposed(by: disposeBag)
            break
        case .replacePassword:
            viewModel.verifyToServerForResetPassword()
                .subscribe(onNext: { response in
                    SVProgressHUD.dismiss()
                    if response.success! {
                        let vm = NewPasswordViewModel.init(resetPasswordToken: response.data!.reset_token!)
                        let vc = NewPasswordViewController.init()
                        vc.viewModel = vm
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        self.showDefaultDialog(message: response.message!, onOkAction: nil)
                    }
                }, onError: { (err) in
                    self.showDefaultDialog(message: err.localizedDescription, onOkAction: nil)
                }).disposed(by: disposeBag)
            break
        default:
            break
        }
    }
}

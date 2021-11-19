//
//  AskPhoneNumberViewController.swift
//  AutismLove
//
//  Created by BobbyPhtr on 28/04/21.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

enum VerificationFlow {
    case replacePassword
    case recoverID
}

class AskPhoneNumberViewController: BaseViewController {
    
    var viewModel : VerificationViewModel!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var backButton: DefaultButton!
    
    @IBOutlet weak var recoverIdTitle: UILabel!
    @IBOutlet weak var recoverIdSubtitle: UILabel!
    
    @IBOutlet weak var mobileNumberField: CustomTextField!
    @IBOutlet weak var sendCodeButton: DefaultButton!
    
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
        
        recoverIdSubtitle.text = Strings.Verification_Subtitle_1
        
        mobileNumberField.setFloatingLabel(Strings.Mobile_Number_Placeholder)
        mobileNumberField.placeholder = Strings.Phone_Placeholder
        
        sendCodeButton.setTitle(Strings.Send_Verification_Number, for: .normal)
        sendCodeButton.primaryBlueStyle()
        
        mobileNumberField.keyboardType = .phonePad
        
    }
    
    private func configureBindings(){
        sendCodeButton.rx.tap
            .bind {
                self.sendVerificationCode()
            }.disposed(by: disposeBag)
        
        mobileNumberField.rx.text
            .bind(to: viewModel.mobileNumberObservable)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind {
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func sendVerificationCode() {
        SVProgressHUD.show(withStatus: Strings.Sending_OTP)
        viewModel.sendVerificationCode { verificationID, error in
            if let _ = verificationID {
                self.showDefaultDialog(message: Strings.OTP_SENT) { [self] in
                    SVProgressHUD.dismiss()
                    if verificationFlowType == .recoverID {
                        let vc = AskVerificationCodeViewController.init(viewModel: viewModel, verificationFlow: .recoverID)
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vc = AskVerificationCodeViewController.init(viewModel: viewModel, verificationFlow: .replacePassword)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            } else {
                SVProgressHUD.dismiss()
                self.showDefaultDialog(message: error!, onOkAction: nil)
            }
        }
    }
    
    //    private func sendVerificationCode(){
    //        SVProgressHUD.show(withStatus: Strings.Sending_OTP)
    //        viewModel.sendVerificationCode()
    //            .subscribe(onNext:{ [unowned self] response in
    //                SVProgressHUD.dismiss()
    //                if response.success == true {
    //                    self.showDefaultDialog(message: Strings.OTP_SENT) {
    //                        if verificationFlowType == .replacePassword {
    //                            let vc = AskVerificationCodeViewController.init(viewModel: viewModel, verificationFlow: .replacePassword)
    //                            self.navigationController?.pushViewController(vc, animated: true)
    //                        } else if verificationFlowType == .recoverID {
    //                            let vc = AskVerificationCodeViewController.init(viewModel: viewModel, verificationFlow: .recoverID)
    //                            self.navigationController?.pushViewController(vc, animated: true)
    //                        }
    //                    }
    //                } else {
    //                    self.showDefaultDialog(message: response.message!, onOkAction: nil)
    //                }
    //            }, onError: { (err) in
    //                SVProgressHUD.dismiss()
    //                self.showDefaultDialog(message: err.localizedDescription, onOkAction: nil)
    //            }).disposed(by: disposeBag)
    //    }
}

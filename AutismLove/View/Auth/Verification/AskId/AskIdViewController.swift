//
//  AskIdViewController.swift
//  AutismLove
//
//  Created by Samuel Krisna on 03/09/21.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class AskIdViewController: BaseViewController {

    @IBOutlet weak var backButton: DefaultButton!
    
    @IBOutlet weak var askIdTitle: UILabel!
    @IBOutlet weak var askIdSubTitle: UILabel!
    
    @IBOutlet weak var idField: CustomTextField!
    @IBOutlet weak var confirmButton: DefaultButton!
    
    // MARK: PROPERTIES
    var verificationFlowType : VerificationFlow?
    
    var viewModel : VerificationViewModel!
    private let disposeBag = DisposeBag()
    
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
        askIdTitle.textColor = .PRIMARY_DARK
        askIdTitle.text = Strings.Replace_Password
        
        askIdSubTitle.text = Strings.Enter_Your_Id
        
        idField.setFloatingLabel(Strings.ID)
        idField.keyboardType = .emailAddress
        idField.placeholder = "abc@abc.com"
        
        confirmButton.setTitle(Strings.Confirm, for: .normal)
        confirmButton.primaryBlueStyle()
    }
    
    private func configureBindings(){
        confirmButton.rx.tap.bind { [unowned self] in
                self.submitId()
            }
            .disposed(by: disposeBag)
        
        idField.rx.text.bind(to: viewModel.idObservable)
            .disposed(by: disposeBag)
        
        backButton.rx.tap.bind {
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func submitId(){
        SVProgressHUD.show()
        viewModel.verifyToServerForID()
            .subscribe(onNext: { response in
                SVProgressHUD.dismiss()
                if response.success! {
                    let vc = AskPhoneNumberViewController.init(viewModel: VerificationViewModel.init(), verificationFlow: .replacePassword)
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.showDefaultDialog(message: response.message!, onOkAction: nil)
                }
            }, onError: { (err) in
                SVProgressHUD.dismiss()
                self.showDefaultDialog(message: err.localizedDescription, onOkAction: nil)
            }).disposed(by: disposeBag)
    }
}

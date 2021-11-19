//
//  PasswordCheckViewController.swift
//  AutismLove
//
//  Created by Samuel Krisna on 27/04/21.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class PasswordCheckViewController: BaseViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var passwordCheckTitle: UILabel!
    @IBOutlet weak var inputYourPasswordLabel: UILabel!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var nextButton: DefaultButton!
    
    var viewModel: GrantRequestViewModel!
    private let disposeBag = DisposeBag()
    
    convenience init(viewModel: GrantRequestViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupBinding()
    }
    
    private func setupView() {
        passwordCheckTitle.text = Strings.Password_Check
        inputYourPasswordLabel.text = Strings.Input_Your_Password
        passwordTextField.setFloatingLabel(Strings.Password)
        nextButton.setTitle(Strings.Next, for: .normal)
        
        hideNavigationController()
        
        view.backgroundColor = .BACKGROUND_LIGHT_GRAY
        
        containerView.backgroundColor = .BACKGROUND_LIGHT_GRAY
        
        passwordCheckTitle.textColor = .PRIMARY_DARK
        passwordTextField.isPassword = true
        
        nextButton.primaryBlueStyle()
    }
    
    func setupBinding() {
        passwordTextField.rx.text.bind(to: viewModel.passwordObservable).disposed(by: disposeBag)
        
        nextButton.rx.tap.bind { [unowned self] in
            checkPassword()
        }.disposed(by: disposeBag)
    }
    
    func checkPassword() {
        SVProgressHUD.show()
        viewModel.checkPassword().subscribe { [unowned self] observer in
            if !observer.success! {
                SVProgressHUD.showError(withStatus: observer.message)
                SVProgressHUD.dismiss(withDelay: SVProgressDelay.Long)
            } else {
                SVProgressHUD.dismiss()
                navigationController?.pushViewController(SignatureViewController.init(viewModel: viewModel), animated: true)
            }
            
        } onError: { error in
            self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
        }.disposed(by: disposeBag)

    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        navigationController?.isNavigationBarHidden = false
    }
}

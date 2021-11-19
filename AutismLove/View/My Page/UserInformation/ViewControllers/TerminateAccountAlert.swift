//
//  TerminateAccountAlert.swift
//  AutismLove
//
//  Created by BobbyPhtr on 15/02/21.
//

import UIKit
import RxSwift
import RxCocoa

class TerminateAccountAlert: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var terminateAccountLabel: UILabel!
    @IBOutlet weak var enterPasswordLabel: UILabel!
    
    @IBOutlet weak var passwordField: CustomTextField!
    
    @IBOutlet weak var closeButton: DefaultButton!
    @IBOutlet weak var cancelButton: DefaultButton!
    @IBOutlet weak var terminateButton: DefaultButton!
    
    var onTerminateTapped = PublishSubject<String?>.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews(){
        // label
        terminateAccountLabel.text = Strings.Terminate_The_Account
        enterPasswordLabel.text = Strings.Enter_Your_Password
        
        // buttons
        closeButton.tintColor = .PRIMARY_DARK
        cancelButton.primaryBlueStyle()
        cancelButton.setTitle(Strings.Cancel, for: .normal)
        terminateButton.redStyle()
        terminateButton.setTitle(Strings.Terminate, for: .normal)
        
        // password field
        passwordField.setFloatingLabel(Strings.Password)
        passwordField.isPassword = true
        
        // Background
        backgroundView.layer.cornerRadius = 8
        backgroundView.layer.shadowRadius = 2
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        backgroundView.layer.shadowOpacity = 0.4
        
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        onTerminateTapped.onNext(passwordField.text)
    }
    
}

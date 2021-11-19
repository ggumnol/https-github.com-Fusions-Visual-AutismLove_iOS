//
//  SignUpChooseUserType.swift
//  AutismLove
//
//  Created by BobbyPhtr on 26/04/21.
//

import UIKit
import M13Checkbox
import RxCocoa
import RxSwift

enum AgreementType {
    case userSignUp
    case privateDataCollection
    case pushNotification
}

class SignUpAgreementVC: BaseViewController {
    
    var viewModel : SignUpViewModel!
    private let disposeBag = DisposeBag()

    @IBOutlet weak var signUpTitle: UILabel!
    @IBOutlet weak var signUpSubtitle: UILabel!
    @IBOutlet weak var agreeAllRadioView: UIView!
    @IBOutlet weak var agreeAllRadioButton: M13Checkbox!
    @IBOutlet weak var agreeAllLabel: UILabel!
    
    @IBOutlet weak var requiredAgreementLabel: UILabel!
    
    @IBOutlet weak var userSignUpRadioBox: M13Checkbox!
    @IBOutlet weak var userSignUpAgreementLabel: UILabel!
    
    @IBOutlet weak var privateDataCollectionAgreementLabel: UILabel!
    @IBOutlet weak var privateDataCollectionAgreementLabelRadioBox: M13Checkbox!
    
    @IBOutlet weak var optionalAgreementLabel: UILabel!
    
    @IBOutlet weak var pushNotificationAgreementLabel: UILabel!
    @IBOutlet weak var pushNotificactionAgreementRadioBox: M13Checkbox!
    
    @IBOutlet weak var signUpButton: DefaultButton!
    
    @IBOutlet weak var userSignUpAgreementBtn: DefaultButton!
    @IBOutlet weak var privateDataCollectionAgreementBtn: DefaultButton!
    @IBOutlet weak var pushNotificationAgreementBtn: DefaultButton!
    
    private lazy var agreementRadios = [pushNotificactionAgreementRadioBox, userSignUpRadioBox, privateDataCollectionAgreementLabelRadioBox]
    private lazy var agreementLabels = [userSignUpAgreementLabel, privateDataCollectionAgreementLabel, pushNotificationAgreementLabel]
    private lazy var agreementDetailButtons = [userSignUpAgreementBtn, privateDataCollectionAgreementBtn, pushNotificationAgreementBtn]
    
    convenience init(viewModel : SignUpViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        configureBindings()
    }

    private func configureViews() {
        signUpTitle.textColor = .PRIMARY_DARK
        
        signUpTitle.text = Strings.Sign_Up
        signUpSubtitle.text = Strings.User_Sign_Up_Subtitle
        agreeAllLabel.text = Strings.Sign_Up_Agree_all
        requiredAgreementLabel.text = Strings.Required_Agreement
        userSignUpAgreementLabel.text = Strings.User_Sign_Up_Agreement
        privateDataCollectionAgreementLabel.text = Strings.Private_Data_Collection_Agreement
        optionalAgreementLabel.text = Strings.Optional_Agreements
        pushNotificationAgreementLabel.text = Strings.Notification_Push_Agreement
        
        agreeAllRadioView.shadowAndRoundCorner()
        agreeAllRadioView.layer.borderWidth = 2.0
        agreeAllRadioView.layer.borderColor = UIColor.SECONDARY_LIGHT_BLUE.cgColor
        agreeAllRadioView.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(onRadioButtonTapped(_:)))
        agreeAllRadioView.addGestureRecognizer(tapGesture)
        
        agreeAllLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        agreeAllLabel?.textColor = .SECONDARY_MEDIUM_BLUE
        
        agreeAllRadioButton.boxType = .circle
        agreeAllRadioButton.markType = .checkmark
        agreeAllRadioButton.stateChangeAnimation = .fill
        agreeAllRadioButton.secondaryTintColor = .SECONDARY_LIGHT_BLUE
        agreeAllRadioButton.isUserInteractionEnabled = false
        
        agreementRadios.forEach {
            $0?.boxType = .square
            $0?.markType = .checkmark
            $0?.stateChangeAnimation = .fill
            $0?.secondaryTintColor = .SECONDARY_LIGHT_BLUE
            $0?.addTarget(self, action: #selector(onAgreementsChanged), for: .valueChanged)
        }
        
        agreementLabels.forEach {
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(onAgreementLabelTapped))
            $0?.addGestureRecognizer(tapGesture)
            $0?.isUserInteractionEnabled = true
        }
        
        agreementDetailButtons.forEach {
            $0?.tintColor = .PRIMARY_DARK
        }
        
        signUpButton.primaryBlueStyle()
        signUpButton.setTitle(Strings.Next, for: .normal)
        
    }
    
    private func configureBindings(){
        signUpButton.rx.tap
            .bind { [unowned self] in
                if !viewModel.agreeToAllRequiredAgreementsObservable.value {
                    self.showDefaultDialog(message: Strings.Sign_Up_Agreements_Alert, onOkAction: nil)
                } else {
                    // Check for push notifications
                    if pushNotificactionAgreementRadioBox.checkState == .checked {
                        let delegate = UIApplication.shared.delegate as! AppDelegate
                        delegate.registerForPushNotifications { isGranted in
                            // User granted push notifications
                            if isGranted {
                                DispatchQueue.main.async {
                                    goToNextStep()
                                }
                            } else {
                                // Try to ask user to activate it from settings
                                DispatchQueue.main.async {
                                    self.showDefaultDialog(message: "Please enable notifications again from Settings") {
                                       directUserToAppSettings()
                                    }
                                }
                               
                                pushNotificactionAgreementRadioBox.setCheckState(.unchecked, animated: true)
                            }
                        }
                    } else {
                        goToNextStep()
                    }
                }
            }.disposed(by: disposeBag)
        
        Observable.merge(
            userSignUpAgreementBtn.rx.tap.map { _ in return AgreementType.userSignUp },
            privateDataCollectionAgreementBtn.rx.tap.map { _ in return AgreementType.privateDataCollection },
            pushNotificationAgreementBtn.rx.tap.map { _ in return AgreementType.pushNotification }
        ).subscribe(onNext: { [unowned self] type in
            switch type {
            case .userSignUp:
                print("Show User Sign Up Agreement")
                let vc = PDFPopUp.init(fileUrl: viewModel.getDocuments(agreementType: .userSignUp))
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.navigationController?.present(vc, animated: true, completion: nil)
                break
            case .privateDataCollection:
                let vc = PDFPopUp.init(fileUrl: viewModel.getDocuments(agreementType: .privateDataCollection))
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.navigationController?.present(vc, animated: true, completion: nil)
                print("Show Private Data Collection Agreement")
                break
            case .pushNotification:
                let vc = PDFPopUp.init(fileUrl: viewModel.getDocuments(agreementType: .pushNotification))
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.navigationController?.present(vc, animated: true, completion: nil)
                print("Show Push Notification Agreement")
                break
            }
        }).disposed(by: disposeBag)
            
    }
    
    private func directUserToAppSettings(){
        if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }
    }
    
    @objc private func onAgreementLabelTapped(_ sender : UITapGestureRecognizer){
        switch sender.view {
        // TODO: Based on the storyboard, the labels open the agreement details
        case userSignUpAgreementLabel:
            print("Show User Sign Up Agreement")
            let vc = PDFPopUp.init(fileUrl: viewModel.getDocuments(agreementType: .userSignUp))
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc, animated: true, completion: nil)
//            userSignUpRadioBox.toggleCheckState(true)
            break
        case privateDataCollectionAgreementLabel:
            print("Show Private Data Collection Agreement")
            let vc = PDFPopUp.init(fileUrl: viewModel.getDocuments(agreementType: .privateDataCollection))
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc, animated: true, completion: nil)
//            privateDataCollectionAgreementLabelRadioBox.toggleCheckState(true)
            break
        case pushNotificationAgreementLabel:
            print("Show Push Notification Agreement")
            let vc = PDFPopUp.init(fileUrl: viewModel.getDocuments(agreementType: .pushNotification))
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc, animated: true, completion: nil)
//            pushNotificactionAgreementRadioBox.toggleCheckState(true)
            break
        default:
            break
        }
//        onAgreementsChanged()
    }
    
    @objc private func onAgreementsChanged(){
        var isAllChecked = true
        var isRequiredChecked = true
        
        // check if ALL agreement are checked
        agreementRadios.forEach {
            if $0?.checkState == .unchecked {
                isAllChecked = false
            }
        }
        
        // Check if required agreement are checked
        [privateDataCollectionAgreementLabelRadioBox, userSignUpRadioBox].forEach {
            if $0?.checkState == .unchecked {
                isRequiredChecked = false
            }
        }
        viewModel.agreeToAllRequiredAgreementsObservable.accept(isRequiredChecked)
        
        if isAllChecked {
            agreeAllRadioButton.setCheckState(.checked, animated: true)
            agreeAllRadioView.animateBorderColor(toColor: UIColor.SECONDARY_MEDIUM_BLUE, duration: 0.15)
        } else {
            agreeAllRadioButton.setCheckState(.unchecked, animated: true)
            agreeAllRadioView.animateBorderColor(toColor: UIColor.SECONDARY_LIGHT_BLUE, duration: 0.15)
        }
    }
    
    @objc private func onRadioButtonTapped(_ sender : UITapGestureRecognizer){
        if sender.view == agreeAllRadioView {
            if agreeAllRadioButton.checkState == .checked {
                agreeAllRadioButton.setCheckState(.unchecked, animated: true)
                sender.view?.animateBorderColor(toColor: UIColor.SECONDARY_LIGHT_BLUE, duration: 0.15)
                agreementRadios.forEach { $0?.setCheckState(.unchecked, animated: true) }
            } else {
                agreeAllRadioButton.setCheckState(.checked, animated: true)
                sender.view?.animateBorderColor(toColor: UIColor.SECONDARY_MEDIUM_BLUE, duration: 0.15)
                agreementRadios.forEach { $0?.setCheckState(.checked, animated: true) }
            }
        }
        onAgreementsChanged()
    }
    
    private func goToNextStep(){
        guard let vm = self.viewModel else {
            print("Warning, SignUpViewModel is nil, will not proceed to the next part.")
            return }
        let vc = InputForm1VC.init(viewModel: vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//
//  UserInformationViewController.swift
//  AutismLove
//
//  Created by BobbyPhtr on 05/05/21.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class UserInformationViewController: BaseViewController {
    
    // MARK: PROPERTY
    var viewModel : UserInformationViewModel = UserInformationViewModel()
    private let disposeBag = DisposeBag()

    // MARK: OUTLETS
    // Label
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var contactInfoLabel: UILabel!
    @IBOutlet weak var accountInfoLabel: UILabel!
    @IBOutlet weak var contractPeriodStartLabel: UILabel!
    @IBOutlet weak var contractPeriodEndLabel: UILabel!
    @IBOutlet weak var notificationSettingLabel: UILabel!
    @IBOutlet weak var supportAgencyLabel: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!
    
    // View
    @IBOutlet weak var contractPeriodStartView: UIView!
    @IBOutlet weak var contractPeriodEndView: UIView!
    @IBOutlet weak var accountInfoView: UIView!
    @IBOutlet weak var birthdateView: UIView!
    @IBOutlet weak var supportAgencyView: UIView!
    @IBOutlet weak var jobTitleView: UIView!
    
    // Value Label
    @IBOutlet weak var idValueLabel: UILabel!
    @IBOutlet weak var nameValueLabel: UILabel!
    @IBOutlet weak var birthdateValueLabel: UILabel!
    @IBOutlet weak var contactValueLabel: UILabel!
    @IBOutlet weak var accountInfoValueLabel: UILabel!
    @IBOutlet weak var contractPeriodStartValueLabel: UILabel!
    @IBOutlet weak var contractPeriodEndValueLabel: UILabel!
    @IBOutlet weak var supportAgencyValueLabel: UILabel!
    @IBOutlet weak var jobTitleValueLabel: UILabel!
    
    
    @IBOutlet weak var allNotificationSwitch: UISwitch!
    @IBOutlet weak var messageAlertSwitch: UISwitch!
    @IBOutlet weak var requestAlertSwitch: UISwitch!
    @IBOutlet weak var informativeAlertSwitch: UISwitch!
    
    @IBOutlet weak var messageAlertsLabel: UILabel!
    @IBOutlet weak var requestAlertLabel: UILabel!
    @IBOutlet weak var informativeAlertLabel: UILabel!
    
    @IBOutlet weak var editButton: DefaultButton!
    @IBOutlet weak var logoutButton: DefaultButton!
    @IBOutlet weak var changePasswordButton: DefaultButton!
    @IBOutlet weak var terminateAccountButton: DefaultButton!
    
    // MARK: GROUPS
    private lazy var titleLabels = [nameLabel, idLabel, birthdateLabel, contactInfoLabel, accountInfoLabel, contractPeriodStartLabel, notificationSettingLabel, supportAgencyLabel, jobTitleLabel, contractPeriodEndLabel]
    
    private lazy var valueLabels = [idValueLabel, nameValueLabel, birthdateValueLabel, contactValueLabel, accountInfoValueLabel, contractPeriodStartValueLabel, jobTitleValueLabel, supportAgencyValueLabel, contractPeriodEndValueLabel]
    
    private lazy var notificationLabels = [messageAlertsLabel, requestAlertLabel, informativeAlertLabel]
    
    private lazy var notificationSwitches = [allNotificationSwitch, messageAlertSwitch, requestAlertSwitch, informativeAlertSwitch]
    
    // MARK: SYSTEM FUNCTIONS
    convenience init(viewModel : UserInformationViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        configureData()
        configureBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationTitleLogoImage()
        configureData()
    }
    
    // MARK: CONFIGURE VIEWS
    private func configureViews(){
        // Title labels
        titleLabels.forEach {
            $0?.font = UIFont.boldSystemFont(ofSize: 20)
            $0?.textColor = .SECONDARY_MEDIUM_BLUE
        }
        
        // Value labels
        valueLabels.forEach {
            $0?.textColor = .lightGray
            $0?.font = UIFont.systemFont(ofSize: 16)
        }
        
        // Notification labels
        notificationLabels.forEach {
            $0?.textColor = .gray
            $0?.font = UIFont.boldSystemFont(ofSize: 18)
        }
        
        // Notification switches
        notificationSwitches.forEach {
            $0?.onTintColor = .SECONDARY_LIGHT_BLUE
            $0?.tintColor = .BACKGROUND_LIGHT_GRAY
            $0?.thumbTintColor = .SECONDARY_MEDIUM_BLUE
        }
        
        // buttons
        editButton.primaryBlueStyle()
        logoutButton.primaryBlueStyle()
        changePasswordButton.primaryBlueStyle()
        terminateAccountButton.redStyle()
        
        // strings
        idLabel.text = Strings.ID
        nameLabel.text = Strings.Name
        birthdateLabel.text = Strings.Birthdate
        contactInfoLabel.text = Strings.Contact_Info
        accountInfoLabel.text = Strings.Account_Info
        contractPeriodStartLabel.text = "신탁 계좌"
        contractPeriodEndLabel.text = Strings.Contract_Period
        notificationSettingLabel.text = Strings.Notification_Setting
        messageAlertsLabel.text = Strings.Message_Alerts
        requestAlertLabel.text = Strings.Request_Alerts
        informativeAlertLabel.text = Strings.Informative_Alerts
        supportAgencyLabel.text = Strings.Support_Agency
        jobTitleLabel.text = Strings.Job_Title
        
        editButton.setTitle(Strings.Edit, for: .normal)
        logoutButton.setTitle(Strings.Logout, for: .normal)
        changePasswordButton.setTitle(Strings.Change_Password, for: .normal)
        terminateAccountButton.setTitle(Strings.Terminate_Account, for: .normal)
    }
    
    // MARK: CONFIGURE DATA
    private func configureData(){
        switch viewModel.userData?.getUserType {
        case .user:
            supportAgencyView.isHidden = true
            jobTitleView.isHidden = true
            break
        case .volunteer:
            accountInfoView.isHidden = true
            contractPeriodStartView.isHidden = true
            contractPeriodEndView.isHidden = true
            supportAgencyView.isHidden = true
            jobTitleView.isHidden = true
            break
        case .supportAgency:
            birthdateView.isHidden = true
            accountInfoView.isHidden = true
            contractPeriodStartView.isHidden = true
            contractPeriodEndView.isHidden = true
            break
        default:
            break
        }
        idValueLabel.text = viewModel.userData?.email
        nameValueLabel.text = viewModel.userData?.name
        birthdateValueLabel.text = viewModel.userData?.birthdate
        contactValueLabel.text = viewModel.userData?.phoneNumber
        supportAgencyValueLabel.text = viewModel.userData?.supportAgency
        jobTitleValueLabel.text = viewModel.userData?.jobTitle
        
        if viewModel.userData?.bankName != nil && viewModel.userData?.bankAccountNumber != nil {
            if let bankName = viewModel.userData?.bankName, let bankAccountNumber = viewModel.userData?.bankAccountNumber {
                contractPeriodStartValueLabel.text = "\(bankName) - \(bankAccountNumber)"
            }
        } else {
            contractPeriodStartValueLabel.text = "신탁 계좌를 등록 해주세요"
        }
        
        if let start = viewModel.userData?.contractPeriodStart, let end = viewModel.userData?.contractPeriodEnd {
            contractPeriodEndValueLabel.text = "\(start) - \(end)"
        }
        
        accountInfoValueLabel.text = "\(viewModel.userData?.bankName ?? "") \(viewModel.userData?.bankAccountNumber ?? "")"
        
        messageAlertSwitch.setOn(viewModel.userData?.isShowMessageNotif ?? false, animated: false)
        requestAlertSwitch.setOn(viewModel.userData?.isShowRequestNotif ?? false, animated: false)
        informativeAlertSwitch.setOn(viewModel.userData?.isShowInformativeNotif ?? false, animated: false)
        
        if viewModel.userData?.isShowMessageNotif == true && viewModel.userData?.isShowRequestNotif == true && viewModel.userData?.isShowInformativeNotif == true {
            allNotificationSwitch.setOn(true, animated: false)
        } else {
            allNotificationSwitch.setOn(false, animated: false)
        }
        
    }
    
    // MARK: CONFIGURE BINDINGS
    private func configureBindings(){
        
        allNotificationSwitch.addTarget(self, action: #selector(allNotificationSwitchValueChanged(_:)), for: .valueChanged)
        messageAlertSwitch.addTarget(self, action: #selector(anyNotificationSwitchValueChanged(_:)), for: .valueChanged)
        requestAlertSwitch.addTarget(self, action: #selector(anyNotificationSwitchValueChanged(_:)), for: .valueChanged)
        informativeAlertSwitch.addTarget(self, action: #selector(anyNotificationSwitchValueChanged(_:)), for: .valueChanged)
        
        editButton.rx.tap
            .bind { [unowned self] in
                let vc = EditUserViewController.init(viewModel : viewModel)
                navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .bind { [unowned self] in
//                logout()
                showLogoutAlert()
            }
            .disposed(by: disposeBag)
        
        changePasswordButton.rx.tap
            .bind { [unowned self] in
                replacePassword()
            }
            .disposed(by: disposeBag)
        
        terminateAccountButton.rx.tap
            .bind { [unowned self] in
                showTerminatePopUp()
            }
            .disposed(by: disposeBag)
        
        Observable.of(allNotificationSwitch.rx.isOn, messageAlertSwitch.rx.isOn, requestAlertSwitch.rx.isOn, informativeAlertSwitch.rx.isOn)
            .merge()
            .debounce(.milliseconds(1500), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                self.viewModel.updateNotification(
                    showMessage: self.messageAlertSwitch.isOn,
                    showRequest: self.requestAlertSwitch.isOn,
                    showInformative: self.informativeAlertSwitch.isOn)
                    .subscribe(onCompleted: self.viewModel.refreshUserData) { err in
                    self.showDefaultDialog(message: err.localizedDescription, onOkAction: nil)
                }.disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
    }
    
    @objc func allNotificationSwitchValueChanged(_ sender : UISwitch){
        if sender.isOn {
            messageAlertSwitch.setOn(true, animated: true)
            requestAlertSwitch.setOn(true, animated: true)
            informativeAlertSwitch.setOn(true, animated: true)
        } else {
            messageAlertSwitch.setOn(false, animated: true)
            requestAlertSwitch.setOn(false, animated: true)
            informativeAlertSwitch.setOn(false, animated: true)
        }
    }
    
    @objc func anyNotificationSwitchValueChanged(_ sender : UISwitch) {
        // check is all notification is On for allNotificationSwitch
        var isAllSwitchedOn = true
        for switcher in [messageAlertSwitch, requestAlertSwitch, informativeAlertSwitch] {
            if switcher?.isOn == false {
                allNotificationSwitch.setOn(false, animated: true)
                isAllSwitchedOn = false
                break
            }
        }
        if isAllSwitchedOn {
            allNotificationSwitch.setOn(true, animated: true)
        }
    }
    
    // MARK: UPDATE NOTIF
    func updateNotification(){
        viewModel.updateNotification(showMessage: messageAlertSwitch.isOn, showRequest: requestAlertSwitch.isOn, showInformative: informativeAlertSwitch.isOn)
            .subscribe(onCompleted: nil) { err in
                self.showDefaultDialog(message: err.localizedDescription, onOkAction: nil)
            }.disposed(by: disposeBag)
    }
    
    func showLogoutAlert() {
        let alert = UIAlertController(title: "\(Strings.Logout)?", message: Strings.Will_You_Logout,preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: Strings.Cancel, style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        
        alert.addAction(UIAlertAction(title: Strings.Logout,
                                      style: UIAlertAction.Style.default,
                                      handler: { [self](_: UIAlertAction!) in
                                        logout()
                                      }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: LOGOUT
    func logout(){
        SVProgressHUD.show(withStatus: Strings.Loading)
        viewModel.onLogOut()
            .subscribe {
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
    
    // MARK: REPLACE PASSWORD
    func replacePassword(){
        let vm = VerificationViewModel.init()
        let changePass = AskPhoneNumberViewController.init(viewModel: vm, verificationFlow: .replacePassword)
        changePass.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(changePass, animated: true)
    }
    
    // MARK: TERMINATE POPUP
    func showTerminatePopUp(){
        let terminationAlert = TerminateAccountAlert.init()
        terminationAlert.onTerminateTapped
            .subscribe(onNext : { [weak self] password in
                if password != nil {
                    SVProgressHUD.show(withStatus: Strings.Loading)
                    self?.viewModel.terminateAccount(password: password ?? "")
                        .subscribe(onCompleted: {
                            SVProgressHUD.dismiss()
                            self?.showDefaultDialog(message: Strings.Your_Account_Has_Been_Terminated, onOkAction: {
                                let scene = UIApplication.shared.connectedScenes.first
                                if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                                    sd.switchToLogin()
                                }
                            })
                        }, onError: { err in
                            SVProgressHUD.dismiss()
                            self?.showDefaultDialog(message: err.localizedDescription, onOkAction: nil)
                        }, onDisposed: nil)
                        .disposed(by: self!.disposeBag)
                }
            })
            .disposed(by: disposeBag)
        terminationAlert.modalTransitionStyle = .crossDissolve
        terminationAlert.modalPresentationStyle = .overFullScreen
        navigationController?.present(terminationAlert, animated: true, completion: nil)
    }

}

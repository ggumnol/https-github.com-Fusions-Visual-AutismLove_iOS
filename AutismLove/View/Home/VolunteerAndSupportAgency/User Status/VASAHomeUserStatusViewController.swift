//
//  VASAHomeUserStatusViewController.swift
//  AutismLove
//
//  Created by Samuel Krisna on 10/06/21.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class VASAHomeUserStatusViewController: BaseViewController, UIDocumentInteractionControllerDelegate {

    @IBOutlet weak var userInformationLabel: UILabel!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var idTitleLabel: UILabel!
    @IBOutlet weak var birthdateTitleLabel: UILabel!
    @IBOutlet weak var contactInfoTitleLabel: UILabel!
    @IBOutlet weak var accountInfoTitleLabel: UILabel!
    @IBOutlet weak var contractPeriodTitleLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var contactInfoLabel: UILabel!
    @IBOutlet weak var accountInfoLabel: UILabel!
    @IBOutlet weak var contractPeriodLabel: UILabel!
    
    @IBOutlet weak var viewSupportPlanButton: DefaultButton!
    @IBOutlet weak var viewContractButton: DefaultButton!
    @IBOutlet weak var viewUserAggrementButton: DefaultButton!
    @IBOutlet weak var messageButton: DefaultButton!
    @IBOutlet weak var callButton: DefaultButton!
    
    private lazy var titleLabels = [nameTitleLabel, idTitleLabel, birthdateTitleLabel, contactInfoTitleLabel, accountInfoTitleLabel, contractPeriodTitleLabel]
    private lazy var valueLabels = [nameLabel, idLabel, birthdateLabel, contactInfoLabel, accountInfoLabel, contractPeriodLabel]
    
    var viewModel: HomeViewModel!
    private let disposeBag = DisposeBag()
    
    convenience init(viewModel: HomeViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupData()
        setupBindings()
    }
    
    func setupView() {
        navigationTitleLogoImage()
        
        userInformationLabel.text = Strings.User_Information
        nameTitleLabel.text = Strings.Name
        idTitleLabel.text = Strings.ID
        birthdateTitleLabel.text = Strings.Birthdate
        contactInfoTitleLabel.text = Strings.Contact_Info
        accountInfoTitleLabel.text = Strings.Account_Info
        contractPeriodTitleLabel.text = Strings.Contract_Period_
        
        viewSupportPlanButton.setTitle(Strings.View_Support_Plan, for: .normal)
        viewContractButton.setTitle(Strings.View_Contacts, for: .normal)
        viewUserAggrementButton.setTitle(Strings.View_User_Agreement, for: .normal)
        messageButton.setTitle(Strings.Message, for: .normal)
        callButton.setTitle(Strings.Call, for: .normal)
        
        // Title labels
        titleLabels.forEach {
            $0?.font = UIFont.boldSystemFont(ofSize: 20)
            $0?.textColor = .PRIMARY_DARK
        }
        
        // Value labels
        valueLabels.forEach {
            $0?.textColor = .lightGray
            $0?.font = UIFont.systemFont(ofSize: 16)
        }
        
        viewSupportPlanButton.secondaryBlueStyle()
        viewContractButton.secondaryBlueStyle()
        viewUserAggrementButton.secondaryBlueStyle()
        
        messageButton.setTitleColor(.PRIMARY_DARK, for: .normal)
        callButton.setTitleColor(.PRIMARY_DARK, for: .normal)
    }
    
    func setupData() {
        nameLabel.text = viewModel.assignedUser.name
        idLabel.text = viewModel.assignedUser.id
        birthdateLabel.text = viewModel.assignedUser.birthdate
        contactInfoLabel.text = viewModel.assignedUser.phoneNumber
        accountInfoLabel.text = viewModel.assignedUser.bankAccountNumber
        if let start = viewModel.assignedUser.contractPeriodStart, let end = viewModel.assignedUser.contractPeriodEnd {
            contractPeriodLabel.text = "\(start) - \(end)"
        }
    }
    
    func setupBindings() {
        viewSupportPlanButton.rx.tap.subscribe { [self] in
            viewModel.getSupportPlan()
                .subscribe { response in
                    self.showPdfPopUp(pdfUrl: response.directoryPath!)
                } onFailure: { err in
                    self.showSystemErrorAlert(message: err.localizedDescription)
                } onDisposed: {}
                .disposed(by: disposeBag)
        } onError: { error in
            self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
        }.disposed(by: disposeBag)
        
        viewContractButton.rx.tap.subscribe { [self] in
            viewModel.getViewContracts()
                .subscribe { response in
                    self.showPdfPopUp(pdfUrl: response.directoryPath!)
                } onFailure: { err in
                    self.showSystemErrorAlert(message: err.localizedDescription)
                } onDisposed: {}
                .disposed(by: disposeBag)
        } onError: { error in
            self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
        }.disposed(by: disposeBag)
        
        viewUserAggrementButton.rx.tap.subscribe { [self] in
            viewModel.getUserAgreements()
                .subscribe { response in
                    self.showPdfPopUp(pdfUrl: response.directoryPath!)
                } onFailure: { err in
                    self.showSystemErrorAlert(message: err.localizedDescription)
                } onDisposed: {}
                .disposed(by: disposeBag)
        } onError: { error in
            self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
        }.disposed(by: disposeBag)
        
        messageButton.rx.tap.subscribe { [self] in
            doSms(phoneNum: viewModel.assignedUser.phoneNumber!, name: viewModel.assignedUser.name!)
        } onError: { error in
            self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
        }.disposed(by: disposeBag)
        
        callButton.rx.tap.subscribe { [self] in
            doCall(phoneNum: viewModel.assignedUser.phoneNumber!)
        } onError: { error in
            self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
        }.disposed(by: disposeBag)
    }
    
    private func showPdfPopUp(pdfUrl : URL){
        let vc = PDFPopUp.init(fileUrl: pdfUrl)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        
        vc.onPDFDownloadTappedObservable
            .subscribe(onNext: { _ in
                let interaction = UIDocumentInteractionController.init(url: pdfUrl)
                interaction.delegate = self
                interaction.presentPreview(animated: true)
            }).disposed(by: disposeBag)
        
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}

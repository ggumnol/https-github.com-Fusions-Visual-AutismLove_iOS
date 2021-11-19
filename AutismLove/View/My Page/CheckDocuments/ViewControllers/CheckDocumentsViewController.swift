//
//  CheckDocumentsViewController.swift
//  AutismLove
//
//  Created by BobbyPhtr on 05/05/21.
//

import UIKit
import RxSwift
import RxCocoa

class CheckDocumentsViewController: BaseViewController {
    
    var viewModel : CheckDocumentsViewModel = CheckDocumentsViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var viewContractsView: UIView!
    @IBOutlet weak var viewSupportPlanView: UIView!
    @IBOutlet weak var viewUserAgreementsView: UIView!
    @IBOutlet weak var viewManagerView: UIView!
    @IBOutlet weak var viewVolunteerView: UIView!
    
    @IBOutlet weak var viewContractsLabel: UILabel!
    @IBOutlet weak var viewSupportLabel: UILabel!
    @IBOutlet weak var viewUserAgreementsLabel: UILabel!
    @IBOutlet weak var viewManagerLabel: UILabel!
    @IBOutlet weak var viewVolunteerLabel: UILabel!
    
    private lazy var menuViews = [viewContractsView, viewSupportPlanView, viewUserAgreementsView, viewManagerView, viewVolunteerView]
    
    private lazy var menuLabels = [viewContractsLabel, viewUserAgreementsLabel, viewSupportLabel, viewManagerLabel, viewVolunteerLabel]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureViews()
        title = Strings.Check_My_Documents
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationController()
        getUserDetail()
    }
    
    private func configureViews(){
        menuViews.forEach {
            $0?.shadowAndRoundCorner()
            $0?.backgroundColor = .white
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(menuTapped(_:)))
            $0?.addGestureRecognizer(tap)
        }
        
        menuLabels.forEach {
            $0?.textColor = .PRIMARY_DARK
        }
        
        viewContractsLabel.text = Strings.View_Contacts
        viewSupportLabel.text = Strings.View_Support_Plan
        viewUserAgreementsLabel.text = Strings.View_User_Agreement
        viewManagerLabel.text = Strings.View_Manager_Information
        viewVolunteerLabel.text = Strings.View_Volunteer_Information
    }
    
    @objc private func menuTapped(_ sender : UITapGestureRecognizer) {
        switch sender.view {
        case viewContractsView:
            if let pdfUrl = viewModel.getPdf(fileType: .contracts) {
                showPdfPopUp(pdfUrl: pdfUrl)
            } else {
                viewModel.getViewContracts()
                    .subscribe { response in
                        self.showPdfPopUp(pdfUrl: response.directoryPath!)
                    } onFailure: { err in
                        self.showSystemErrorAlert(message: err.localizedDescription)
                    } onDisposed: {}
                    .disposed(by: disposeBag)
            }
            break
        case viewSupportPlanView:
            if let pdfUrl = viewModel.getPdf(fileType: .supportPlan) {
                showPdfPopUp(pdfUrl: pdfUrl)
            } else {
                viewModel.getSupportPlan()
                    .subscribe { response in
                        self.showPdfPopUp(pdfUrl: response.directoryPath!)
                    } onFailure: { err in
                        self.showSystemErrorAlert(message: err.localizedDescription)
                    } onDisposed: {}
                    .disposed(by: disposeBag)
            }
        case viewUserAgreementsView:
            if let pdfUrl = viewModel.getPdf(fileType: .userAgreement) {
                showPdfPopUp(pdfUrl: pdfUrl)
            } else {
                viewModel.getUserAgreements()
                    .subscribe { response in
                        self.showPdfPopUp(pdfUrl: response.directoryPath!)
                    } onFailure: { err in
                        self.showSystemErrorAlert(message: err.localizedDescription)
                    } onDisposed: {}
                    .disposed(by: disposeBag)
            }
            break
        case viewManagerView:
            if let model = viewModel.getManagerInfo() {
                let vc = ShowInfoPopUp.init(userType: .supportAgency, model: model)
                vc.onCallObservable.subscribe(onNext: { [weak self] type in
                    if type != nil{
                        self?.onCallTapped(userType: type!)
                    }
                }).disposed(by: disposeBag)
                vc.onMessageObservable.subscribe(onNext: { [weak self] type in
                    if type != nil {
                        self?.onMessageTapped(userType: type!)
                    }
                }).disposed(by: disposeBag)
                present(vc, animated: true, completion: nil)
            } else {
                getUserDetail()
            }
            break
        case viewVolunteerView:
            if let model = viewModel.getVolunteerInfo() {
                let vc = ShowInfoPopUp.init(userType: .volunteer, model: model)
                vc.onCallObservable.subscribe(onNext: { [weak self] type in
                    if type != nil{
                        self?.onCallTapped(userType: type!)
                    }
                }).disposed(by: disposeBag)
                vc.onMessageObservable.subscribe(onNext: { [weak self] type in
                    if type != nil {
                        self?.onMessageTapped(userType: type!)
                    }
                }).disposed(by: disposeBag)
                present(vc, animated: true, completion: nil)
            } else {
                getUserDetail()
            }
            break
        default:
            break
        }
    }
    
    
    /// Show PDF Pop Up
    /// - Parameter pdfUrl: pdf URL
    private func showPdfPopUp(pdfUrl : URL){
        let vc = PDFPopUp.init(fileUrl: pdfUrl)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        
        vc.onPDFDownloadTappedObservable
            .subscribe(onNext: { _ in
//                do {
//                    try FileManager.default.copyItem(at: pdfUrl, to: FileManager.default.url(for: .downloadsDirectory, in: .allDomainsMask, appropriateFor: nil, create: false))
//                } catch {
//                    print(error)
//                    self.showSystemErrorAlert(message: error.localizedDescription)
//                }
                let interaction = UIDocumentInteractionController.init(url: pdfUrl)
                interaction.delegate = self
                interaction.presentPreview(animated: true)
                
            }).disposed(by: disposeBag)
        
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    /// Get User Detail
    private func getUserDetail(){
        // Get the user detail immediately
        viewModel.getUserDetail()
            .subscribe {
                //
            } onError: { err in
                self.showSystemErrorAlert(message: err.localizedDescription)
            } onDisposed: {
                //
            }
            .disposed(by: disposeBag)
    }
    
    private func onCallTapped(userType : UserType){
        print("On Call \(userType)")
        switch userType {
        case .supportAgency:
            doCall(phoneNum: viewModel.managerInfoObservable.value!.contactInfo!)
            break
        case .volunteer:
            doCall(phoneNum: viewModel.volunteerInfoObservable.value!.contactInfo!)
            break
        default:
            break
        }
        
    }
    
    private func onMessageTapped(userType : UserType){
        print("On message \(userType)")
        switch userType {
        case .supportAgency:
            doSms(phoneNum: viewModel.managerInfoObservable.value!.contactInfo!, name: viewModel.managerInfoObservable.value!.name!)
            break
        case .volunteer:
            doSms(phoneNum: viewModel.volunteerInfoObservable.value!.contactInfo!, name: viewModel.volunteerInfoObservable.value!.name!)
            break
        default:
            break
        }
        
    }
    
}

extension CheckDocumentsViewController : UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

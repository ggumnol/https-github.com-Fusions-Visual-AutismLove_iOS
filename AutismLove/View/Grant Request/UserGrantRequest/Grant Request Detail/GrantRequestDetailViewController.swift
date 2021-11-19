//
//  GrantRequestDetailViewController.swift
//  AutismLove
//
//  Created by Samuel Krisna on 17/05/21.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD
import Kingfisher

class GrantRequestDetailViewController: BaseViewController {
    @IBOutlet weak var reasonForRejectionTitleLabel: UILabel!
    @IBOutlet weak var requestReasonTitleLabel: UILabel!
    @IBOutlet weak var usageTitleLabel: UILabel!
    @IBOutlet weak var grantDateTitleLabel: UILabel!
    @IBOutlet weak var uploadProofImageTitleLabel: UILabel!
    @IBOutlet weak var requesterTitleLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var editButton: DefaultButton!
    @IBOutlet weak var reasonForRejectionTextView: UITextView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var requestReasonTextfield: UITextField!
    @IBOutlet weak var bankTableView: UITableView!
    @IBOutlet weak var bankTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var proofImageCollectionView: UICollectionView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var requesterTextField: UITextField!
    @IBOutlet weak var acceptView: UIView!
    @IBOutlet weak var acceptIcon: UILabel!
    @IBOutlet weak var acceptButton: DefaultButton!
    @IBOutlet weak var rejectView: UIView!
    @IBOutlet weak var rejectIcon: UILabel!
    @IBOutlet weak var rejectButton: DefaultButton!
    @IBOutlet weak var viewGrantRequestDocumentButton: DefaultButton!
    @IBOutlet weak var deleteRequestButton: DefaultButton!
    
    weak var delegate: GrantRequestDelegate?
    
    var viewModel: GrantRequestViewModel!
    private let disposeBag = DisposeBag()
    
    var customImagePicker: CustomImagePicker!
    
    convenience init(viewModel: GrantRequestViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTableViewAndCollectionView()
        setupData()
        setupBinding()
    }
    
    func setupView() {
        navigationTitleLogoImage()
        
        requestReasonTextfield.isEnabled = false
        dateTextField.isEnabled = false
        requesterTextField.isEnabled = false
        
        editButton.setTitle(Strings.Edit, for: .normal)
        reasonForRejectionTitleLabel.text = Strings.Reason_For_Rejection
        requestReasonTitleLabel.text = Strings.GrantRequestFormStrings.Request_Reason_Title
        usageTitleLabel.text = Strings.GrantRequestFormStrings.Usage_Title
        grantDateTitleLabel.text = Strings.GrantRequestFormStrings.Date_Title
        uploadProofImageTitleLabel.text = Strings.GrantRequestFormStrings.Upload_Proof_Title
        requesterTitleLabel.text = Strings.GrantRequestFormStrings.Requester_Title
        acceptButton.setTitle(Strings.Accept, for: .normal)
        rejectButton.setTitle(Strings.Reject, for: .normal)
        viewGrantRequestDocumentButton.setTitle(Strings.View_Grants_Request_Document, for: .normal)
        deleteRequestButton.setTitle(Strings.Delete_Request, for: .normal)
        
        statusLabel.clipsToBounds = true
        statusLabel.backgroundColor = .PRIMARY_DARK
        statusLabel.roundCorners(radius: 7)
        statusLabel.textColor = .white
        
        editButton.lightRedStyle()
        
        if viewModel.statusObservable.value == "ACCEPT" {
            editButton.isEnabled = false
            editButton.backgroundColor = .gray
        } else {
            if viewModel.grantRequestData.requester?.role == "VOLUNTEER" || viewModel.grantRequestData.requester?.role == "SUPPORT_AGENT" {
                if Globals.userData?.id != viewModel.grantRequestData.requester?._id {
                    editButton.isEnabled = false
                    editButton.backgroundColor = .gray
                } else {
                    editButton.isEnabled = true
                    editButton.backgroundColor = .LIGHT_RED
                }
            }
        }
        
        reasonForRejectionTextView.roundCorners(radius: 7)
        reasonForRejectionTextView.backgroundColor = .systemGray6
        
        containerView.backgroundColor = .BACKGROUND_LIGHT_GRAY
        
        requestReasonTextfield.shadowAndRoundCorner()
        
        bankTableView.backgroundColor = .BACKGROUND_LIGHT_GRAY
        
        dateTextField.backgroundColor = .white
        dateTextField.shadowAndRoundCorner()
        
        proofImageCollectionView.backgroundColor = .BACKGROUND_LIGHT_GRAY
        
        requesterTextField.shadowAndRoundCorner()
        
        acceptView.backgroundColor = .PRIMARY_DARK
        rejectView.backgroundColor = .LIGHT_RED
        acceptView.roundCorners(radius: 7)
        rejectView.roundCorners(radius: 7)
        acceptIcon.textColor = .white
        rejectIcon.textColor = .white
        acceptButton.primaryBlueStyle()
        rejectButton.lightRedStyle()
        viewGrantRequestDocumentButton.primaryBlueStyle()
        deleteRequestButton.lightRedStyle()
        
        if viewModel.grantRequestData.requester?._id == Globals.userData?.id {
            acceptButton.isHidden = true
            acceptIcon.isHidden = true
            acceptView.isHidden = true
            
            rejectButton.isHidden = true
            rejectIcon.isHidden = true
            rejectView.isHidden = true
        } else {
            acceptButton.isEnabled = true
            acceptButton.isHidden = false
            acceptIcon.isHidden = false
            acceptView.isHidden = false
            
            rejectButton.isEnabled = true
            rejectButton.isHidden = false
            rejectIcon.isHidden = false
            rejectView.isHidden = false
            
            if viewModel.grantRequestData.status == "ACCEPT" {
                acceptButton.isHidden = true
                acceptIcon.isHidden = true
                acceptView.isHidden = true
                
                rejectButton.isHidden = true
                rejectIcon.isHidden = true
                rejectView.isHidden = true
            } else if viewModel.grantRequestData.status == "REJECT" {
                rejectButton.isEnabled = false
//                acceptView.backgroundColor = .green
//                acceptButton.backgroundColor = .green
//                rejectView.backgroundColor = .gray
//                rejectButton.backgroundColor = .gray
            } else {
                
            }
        }
    }
    
    private func setupTableViewAndCollectionView() {
        bankTableView.delegate = self
        bankTableView.dataSource = self
        
        let bankCell = UINib(nibName: "BankTableViewCell", bundle: nil)
        bankTableView.register(bankCell, forCellReuseIdentifier: "bankTableViewCell")
        
        proofImageCollectionView.delegate = nil
        proofImageCollectionView.dataSource = nil
        proofImageCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let proofImageCell = UINib(nibName: "ProofImageCollectionViewCell", bundle: nil)
        proofImageCollectionView.register(proofImageCell, forCellWithReuseIdentifier: "proofImageCollectionViewCell")
    }
    
    func setupData() {
        reasonForRejectionTitleLabel.isHidden = true
        reasonForRejectionTextView.isHidden = true
        
        if viewModel.statusObservable.value == "REJECT" {
            reasonForRejectionTitleLabel.isHidden = false
            reasonForRejectionTextView.isHidden = false
        }
        
        statusLabel.text = Strings.Proof_Completed
        statusLabel.textColor = .white
        statusLabel.backgroundColor = .SECONDARY_MEDIUM_BLUE
        if viewModel.imageOfProofObservable.value.isEmpty {
            statusLabel.text = Strings.Upload_Proof
            statusLabel.textColor = .white
            statusLabel.backgroundColor = .SECONDARY_MEDIUM_BLUE
        }
        
        if viewModel.grantRequestData.rejected_by.count != 0 {
            let rejected_by = viewModel.grantRequestData.rejected_by
            var names:[String] = []
            var reasons:[String] = []
            
            for rejected in rejected_by {
                names.append((rejected?.user?.name)!)
                reasons.append((rejected?.rejected_reason)!)
            }
            
            reasonForRejectionTextView.text = "\(names.joined(separator: ",")) - \(reasons.joined(separator: ","))"
        }
        
        requestReasonTextfield.text = viewModel.requestReasonObservable.value
        dateTextField.text = viewModel.grantDateObservable.value
        requesterTextField.text = viewModel.requesterNameObservable.value

        customImagePicker = CustomImagePicker(presentationController: self, delegate: self)
    }
    
    func setupBinding() {
        editButton.rx.tap.bind { [self] in
            print(viewModel.statusObservable.value!)
            let vc = EditGrantRequestViewController.init(viewModel: viewModel)
            
            navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
        reasonForRejectionTextView.rx.text
            .bind(to: viewModel.rejectedReasonObservable)
            .disposed(by: disposeBag)
        
        viewModel.imageOfProofObservable.bind(to: proofImageCollectionView.rx.items(cellIdentifier: "proofImageCollectionViewCell", cellType: ProofImageCollectionViewCell.self)) { row, item, cell in
            if item != nil {
                let url = URL(string: "\(URLs.BASE_URL)\(item!)")
                cell.setupData(imageUrl: url!)
            }
        }.disposed(by: disposeBag)
        
        proofImageCollectionView.rx.modelSelected(String.self).subscribe { url in
            let path = String(describing: url.element!)
            print("Path: \(path)")
            
            let url = URL(string: "\(URLs.BASE_URL)\(path)")
            print("URL: \(String(describing: url))")
            
            let vc = FullViewImageViewController()
            vc.setupData(imageUrl: url!)
            vc.modalPresentationStyle = .popover
            
            self.present(vc, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        acceptButton.rx.tap.bind { [unowned self] in
            updateGrantRequest(action: "ACCEPT")
        }.disposed(by: disposeBag)
        
        rejectButton.rx.tap.bind { [unowned self] in
            updateGrantRequest(action: "REJECT")
        }.disposed(by: disposeBag)
        
        viewGrantRequestDocumentButton.rx.tap.bind { [self] in
            viewGrantRequestDocument()
        }.disposed(by: disposeBag)
        
        deleteRequestButton.rx.tap.bind { [unowned self] in
            deleteGrantRequest()
        }.disposed(by: disposeBag)
    }
    
    func updateGrantRequest(action: String) {
        SVProgressHUD.show()
        viewModel.updateGrantRequest(action: action).subscribe {
            SVProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
        } onError: { error in
            SVProgressHUD.dismiss()
            self.showDefaultDialog(message: "\(error.localizedDescription)", onOkAction: nil)
        }.disposed(by: disposeBag)
    }
    
    func viewGrantRequestDocument() {
        SVProgressHUD.show(withStatus: Strings.Loading)
        viewModel.downloadGRDocument(id: viewModel.grantRequestIdObservable.value).subscribe { url in
            SVProgressHUD.dismiss()
            if let urlStr = url {
                let vc = UIActivityViewController(activityItems: [urlStr], applicationActivities: nil)
                self.present(vc, animated: true, completion: nil)
            } else {
                print("No URL")
            }
        } onFailure: { error in
            SVProgressHUD.dismiss()
            self.showSystemErrorAlert(message: error.localizedDescription)
        }.disposed(by: disposeBag)
    }
    
    private func deleteGrantRequest() {
        SVProgressHUD.show(withStatus: "Deleting")
        viewModel.deleteGrantRequest().subscribe { [self] in
            SVProgressHUD.dismiss()
            delegate?.refreshData()
            self.navigationController?.popViewController(animated: true)
        } onError: { error in
            SVProgressHUD.dismiss()
            self.showDefaultDialog(message: "\(error.localizedDescription)", onOkAction: nil)
        }.disposed(by: disposeBag)
    }
}

extension GrantRequestDetailViewController: ImagePickerPrtcl {
    func didSelect(image: UIImage?) {
        viewModel.proofOfImagesList.append(image)
        proofImageCollectionView.reloadData()
    }
}

extension GrantRequestDetailViewController: UITableViewDelegate, UITableViewDataSource {
    override func viewWillAppear(_ animated: Bool) {
        bankTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        bankTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        bankTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newvalue = change?[.newKey] {
                let newsize = newvalue as! CGSize
                bankTableViewHeight.constant = newsize.height
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.usagesObservable.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bankTableViewCell") as! BankTableViewCell
        
        cell.setupData(usage: viewModel.usagesObservable.value[indexPath.row]!)
        cell.deleteUsageButton.isHidden = true
        
        return cell
    }
}

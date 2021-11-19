//
//  EditGrantRequestViewController.swift
//  AutismLove
//
//  Created by Samuel Krisna on 30/05/21.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD
import Kingfisher

class EditGrantRequestViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var requestReasonTitleLabel: UILabel!
    @IBOutlet weak var usageTitleLabel: UILabel!
    @IBOutlet weak var grantDateLabel: UILabel!
    @IBOutlet weak var proofImageTitleLabel: UILabel!
    
    @IBOutlet weak var requestReasonTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var bankTableView: UITableView!
    @IBOutlet weak var bankTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var proofImageCollectionView: UICollectionView!
    
    @IBOutlet weak var submitButton: DefaultButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var submitButtonView: UIView!
    
    static var delegate: GrantRequestDelegate?
    
    var viewModel: GrantRequestViewModel!
    private let disposeBag = DisposeBag()
    
    let date = Date()
    let formatter = DateFormatter()
    let datePicker = UIDatePicker()
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
        
        titleLabel.text = Strings.Edit_Grant_Request
        requestReasonTitleLabel.text = Strings.GrantRequestFormStrings.Request_Reason_Title
        usageTitleLabel.text = Strings.GrantRequestFormStrings.Usage_Title
        grantDateLabel.text = Strings.GrantRequestFormStrings.Date_Title
        proofImageTitleLabel.text = Strings.GrantRequestFormStrings.Upload_Proof_Title
        
        view.backgroundColor = UIColor.BACKGROUND_LIGHT_GRAY
        containerView.backgroundColor = UIColor.BACKGROUND_LIGHT_GRAY
        dateTextField.backgroundColor = .white
        proofImageCollectionView.backgroundColor = UIColor.BACKGROUND_LIGHT_GRAY
        submitButtonView.backgroundColor = .white
        
        requestReasonTextField.shadowAndRoundCorner()
        dateTextField.shadowAndRoundCorner()
        
        submitButton.primaryBlueStyle()
        submitButton.setTitle(Strings.Confirm, for: .normal)
        if viewModel.statusObservable.value == "REJECT" {
            submitButton.setTitle(Strings.Resubmit, for: .normal)
        }
        
        if viewModel.isEditable == false {
            requestReasonTextField.isEnabled = false
            requestReasonTextField.backgroundColor = .lightGray
            
            dateTextField.isEnabled = false
            dateTextField.backgroundColor = .lightGray
        }
    }
    
    func setupData() {
        createDatePicker()
        
        requestReasonTextField.text = viewModel.requestReasonObservable.value
        dateTextField.text = viewModel.grantDateObservable.value
        
        customImagePicker = CustomImagePicker(presentationController: self, delegate: self)
    }
    
    func setupBinding() {
        requestReasonTextField.rx.text
            .bind(to: viewModel.requestReasonObservable)
            .disposed(by: disposeBag)
        
        dateTextField.rx.text
            .bind(to: viewModel.grantDateObservable)
            .disposed(by: disposeBag)
        
//        viewModel.imageOfProofObservable.bind(to: proofImageCollectionView.rx.items(cellIdentifier: "proofImageCollectionViewCell", cellType: ProofImageCollectionViewCell.self)) { row, item, cell in
//            if item != nil {
//                let url = URL(string: "\(URLs.BASE_URL)\(item!)")
//                cell.setupData(imageUrl: url!)
//            }
//        }.disposed(by: disposeBag)
        
        submitButton.rx.tap.bind { [unowned self] in
            print("Id: \(viewModel.grantRequestIdObservable.value!)")
            print("Request Reason: \(viewModel.requestReasonObservable.value!)")
            print("Grant Date: \(viewModel.grantDateObservable.value!)")
            print("Images of Proof: \(viewModel.imageOfProofObservable.value)")
            submit()
        }.disposed(by: disposeBag)
    }
    
    func submit() {
        SVProgressHUD.show()
        viewModel.updateGrantRequest().subscribe { [self] in
            SVProgressHUD.showSuccess(withStatus: "Update grant request successful")
            viewModel.isRefresh = true
            self.navigationController?.popToRootViewController(animated: true)
        } onError: { error in
            SVProgressHUD.dismiss()
            self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
        } onDisposed: {
            SVProgressHUD.dismiss(withDelay: SVProgressDelay.SHORT)
        }.disposed(by: disposeBag)
    }
    
    private func setupTableViewAndCollectionView() {
        bankTableView.delegate = self
        bankTableView.dataSource = self
        
        let emptyBankCell = UINib(nibName: "EmptyBankTableViewCell", bundle: nil)
        bankTableView.register(emptyBankCell, forCellReuseIdentifier: "emptyBankTableViewCell")
        let bankCell = UINib(nibName: "BankTableViewCell", bundle: nil)
        bankTableView.register(bankCell, forCellReuseIdentifier: "bankTableViewCell")
        
        proofImageCollectionView.delegate = self
        proofImageCollectionView.dataSource = self
//        proofImageCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let proofImageCell = UINib(nibName: "ProofImageCollectionViewCell", bundle: nil)
        proofImageCollectionView.register(proofImageCell, forCellWithReuseIdentifier: "proofImageCollectionViewCell")
    }
    
    func createDatePicker() {
        if #available(iOS 13.4, *) {
            datePicker.frame.size = CGSize(width: 0, height: 250)
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = createToolbar()
    }
    
    func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePicker))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelPicker))
        toolbar.setItems([done, space, cancel], animated: true)
        
        return toolbar
    }
    
    @objc func donePicker(){
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: datePicker.date)
        dateTextField.text = dateString
        self.view.endEditing(true)
    }
    
    @objc func cancelPicker(){
        self.view.endEditing(true)
    }
    
    func uploadProofImage(image: UIImage) {
        SVProgressHUD.show()
        viewModel.uploadProofImage(image: image).subscribe {  [unowned self] observer  in
            SVProgressHUD.dismiss()
            if let path = observer.data?.path {
//                viewModel.proofOfImagesList.append(image)
                viewModel.imageOfProofObservable.accept(viewModel.imageOfProofObservable.value + ["\(path)"])
                proofImageCollectionView.reloadData()
            }
        } onError: { error in
            SVProgressHUD.dismiss()
            self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
        }.disposed(by: disposeBag)
    }
}

extension EditGrantRequestViewController: ImagePickerPrtcl {
    func didSelect(image: UIImage?) {
        uploadProofImage(image: image!)
    }
}

extension EditGrantRequestViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if viewModel.isEditable == false {
                return 0
            } else {
                return 1
            }
        default:
            return viewModel.usagesObservable.value.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyBankTableViewCell") as! EmptyBankTableViewCell
            
            cell.addButton.addTarget(self, action: #selector(addBankTapped), for: .touchUpInside)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bankTableViewCell") as! BankTableViewCell
            
            cell.setupData(usage: viewModel.usagesObservable.value[indexPath.row]!)
            cell.deleteUsageButton.tag = indexPath.row
            cell.deleteUsageButton.addTarget(self, action: #selector(deleteUsage), for: .touchUpInside)
            
            if viewModel.isEditable == false {
                cell.deleteUsageButton.isHidden = true
            }
            
            return cell
        }
    }
    
    @objc func addBankTapped() {
        navigationController?.pushViewController(AddEditUsageViewController.init(viewModel: viewModel), animated: true)
    }
    
    @objc func deleteUsage(sender: UIButton) {
        viewModel.usagesObservable.remove(at: sender.tag)
        viewModel.isUsageFilledObservable.accept(false)
        bankTableView.reloadData()
    }
    
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
}

extension EditGrantRequestViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return viewModel.imageOfProofObservable.value.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "proofImageCollectionViewCell", for: indexPath) as! ProofImageCollectionViewCell
        
        switch indexPath.section {
        case 0:
            let img = UIImage(named: "ic_add_image")
            cell.setupData(image: img!)
        default:
            let url = URL(string: URLs.BASE_URL + viewModel.imageOfProofObservable.value[indexPath.row]!)
            cell.setupData(imageUrl: url!)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.customImagePicker.present(from: self.view)
        default:
            let vc = FullViewImageViewController()
            vc.modalPresentationStyle = .popover
            let url = URL(string: "\(URLs.BASE_URL)\(viewModel.imageOfProofObservable.value[indexPath.row]!)")
            vc.setupData(imageUrl: url!)
            present(vc, animated: true, completion: nil)
        }
    }
}

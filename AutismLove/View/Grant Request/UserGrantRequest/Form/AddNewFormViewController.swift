//
//  AddNewFormViewController.swift
//  AutismLove
//
//  Created by Samuel Krisna on 26/04/21.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class AddNewFormViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var requestReasonTitle: UILabel!
    @IBOutlet weak var requestReasonTextview: UITextView!
    @IBOutlet weak var usageTitle: UILabel!
    @IBOutlet weak var bankTableView: UITableView!
    @IBOutlet weak var bankTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dateTitle: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var uploadProofTitle: UILabel!
    @IBOutlet weak var proofImageCollectionView: UICollectionView!
    @IBOutlet weak var uploadLaterLabel: UILabel!
    @IBOutlet weak var uploadLaterCheckbox: DefaultButton!
    @IBOutlet weak var submitButton: DefaultButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var submitButtonView: UIView!
    
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
        hideKeyboardWhenTappedAround()
        setupCheckbox()
        setupData()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bankTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        bankTableView.reloadData()
        proofImageCollectionView.reloadData()
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
    
    private func setupView() {
        navigationTitleLogoImage()
        titleLabel.text = Strings.Grant_Request_Form_Title
        
        submitButtonView.backgroundColor = .white
        
        // Request Reason
        requestReasonTitle.text = Strings.GrantRequestFormStrings.Request_Reason_Title
        requestReasonTextview.shadowAndRoundCorner()
        
        // Usage
        usageTitle.text = Strings.GrantRequestFormStrings.Usage_Title
        containerView.backgroundColor = UIColor.BACKGROUND_LIGHT_GRAY
        proofImageCollectionView.backgroundColor = UIColor.BACKGROUND_LIGHT_GRAY
        
        // Date
        dateTitle.text = Strings.GrantRequestFormStrings.Date_Title
        dateTextField.backgroundColor = .white
        dateTextField.shadowAndRoundCorner()
        
        // Upload Proof
        uploadProofTitle.text = Strings.GrantRequestFormStrings.Upload_Proof_Title
        
        // Upload Later
        uploadLaterLabel.text = Strings.GrantRequestFormStrings.Upload_Later
        
        // Submit button
        submitButton.setTitle(Strings.Submit, for: .normal)
        submitButton.primaryBlueStyle()
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
        
        let proofImageCell = UINib(nibName: "ProofImageCollectionViewCell", bundle: nil)
        proofImageCollectionView.register(proofImageCell, forCellWithReuseIdentifier: "proofImageCollectionViewCell")
    }
    
    func setupData() {
        createDatePicker()
        
        customImagePicker = CustomImagePicker(presentationController: self, delegate: self)
    }
    
    func setupBindings() {
        requestReasonTextview.rx.text
            .bind(to: viewModel.requestReasonObservable).disposed(by: disposeBag)
        
        dateTextField.rx.text
            .bind(to: viewModel.grantDateObservable)
            .disposed(by: disposeBag)
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
    
    private func setupCheckbox() {
        uploadLaterCheckbox.setImage(UIImage(named:"blank-check-box"), for: .normal)
        uploadLaterCheckbox.setImage(UIImage(named:"check-box"), for: .selected)
    }
    
    @IBAction func checktapped(_ sender: DefaultButton) {
        UIView.animate(withDuration: 0, delay: 0, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0, y: 0)
        }) { (success) in
            UIView.animate(withDuration: 0, delay: 0, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
            }, completion: nil)
        }
    }
    
    @IBAction func submitTapped(_ sender: UIButton) {
        viewModel.isUploadLaterCheckedObservable.accept(uploadLaterCheckbox.isSelected)
        validateAddNewFormStage()
    }
    
    func uploadProofImage(image: UIImage) {
        SVProgressHUD.show()
        viewModel.uploadProofImage(image: image).subscribe {  [unowned self] observer  in
            SVProgressHUD.dismiss()
            if let path = observer.data?.path {
                viewModel.proofOfImagesList.append(image)
                viewModel.imageOfProofObservable.accept(viewModel.imageOfProofObservable.value + ["\(path)"])
                proofImageCollectionView.reloadData()
            }
        } onError: { error in
            SVProgressHUD.dismiss()
            self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
        }.disposed(by: disposeBag)
    }
    
    func validateAddNewFormStage() {
        viewModel.validateAddNewFormStage().subscribe { [unowned self] isSuccess in
            if isSuccess == true {
                navigationItem.backButtonTitle = "Back"
                navigationController?.pushViewController(PasswordCheckViewController.init(viewModel: viewModel), animated: true)
            }
        } onFailure: { error in
            self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
        }.disposed(by: disposeBag)
    }
}

extension AddNewFormViewController: ImagePickerPrtcl {
    func didSelect(image: UIImage?) {
        uploadProofImage(image: image!)
    }
}

extension AddNewFormViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
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
}

extension AddNewFormViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return viewModel.proofOfImagesList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "proofImageCollectionViewCell", for: indexPath) as! ProofImageCollectionViewCell
        
        switch indexPath.section {
        case 0:
            let img = UIImage(named: "ic_add_image")
            cell.setupData(image: img!)
        default:
            cell.setupData(image: viewModel.proofOfImagesList[indexPath.row]!)
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
            vc.img = viewModel.proofOfImagesList[indexPath.row]!
            present(vc, animated: true, completion: nil)
        }
    }
}

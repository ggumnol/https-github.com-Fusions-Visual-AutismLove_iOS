//
//  TransactionViewController.swift
//  AutismLove
//
//  Created by Samuel Krisna on 25/04/21.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD
import MaterialComponents

enum FilterSort {
    case newest
    case oldest
    
    var string: String {
        switch self {
        case .newest:
            return Strings.Newest
        case .oldest:
            return Strings.Oldest
        }
    }
    
    var apiKey : String {
        switch self {
        case .newest:
            return "-date"
        case .oldest:
            return "+date"
        }
    }
}

enum FilterMode {
    case today
    case week_1
    case month_1
    case month_6
    case desiredDate
    
    init?(btn : UIButton) {
        switch btn.titleLabel?.text {
        case Strings.Today:
            self = .today
        case Strings.One_Week:
            self = .week_1
        case Strings.One_Month:
            self = .month_1
        case Strings.Six_Months:
            self = .month_6
        case Strings.Desired_Date:
            self = .desiredDate
        default:
            return nil
        }
    }
}

class TransactionViewController: BaseViewController {
    
    var viewModel : TransactionViewModel!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var downloadButton: DefaultButton!
    
    // Labels and Views
    @IBOutlet weak var moneyView: UIView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    // Filter buttons
    @IBOutlet weak var todayButton: DefaultButton!
    @IBOutlet weak var week1Button: DefaultButton!
    @IBOutlet weak var month1Button: DefaultButton!
    @IBOutlet weak var month6Button: DefaultButton!
    @IBOutlet weak var desiredDateButton: DefaultButton!
    
    // Manual Filter buttons
    @IBOutlet weak var startDateFilter: UITextField!
    @IBOutlet weak var endDateFilter: UITextField!
    @IBOutlet weak var searchDateButton: DefaultButton!
    @IBOutlet weak var filterTypeButton: DefaultButton!
    
    @IBOutlet weak var transactionList: UITableView!
    private var refreshControl = UIRefreshControl()
    @IBOutlet weak var loadMoreIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var searchFieldView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var filterButton: DefaultButton!
    
    lazy var currentActiveFilter : DefaultButton = desiredDateButton
    lazy var filterButtons = [todayButton, week1Button, month1Button, month6Button, desiredDateButton]
    
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    
    private var assignedUserData : AssignedUserData?
    
    convenience init(viewModel : TransactionViewModel, assignedUserData : AssignedUserData? = nil) {
        self.init()
        self.viewModel = viewModel
        self.assignedUserData = assignedUserData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureBindings()
        
        getTransactions()
        
        self.navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationController()
        navigationTitleLogoImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButton()
    }
    
    // MARK: CONFIGURE VIEWS
    private func configureView(){
        downloadButton.secondaryBlueStyle()
        
        if let assignedUser = assignedUserData {
            print("assignedUser: \(assignedUser)")
            if let balance = assignedUser.balance {
                moneyLabel.text = "\(balance) 원"
            }
            
            if assignedUser.bankAccountNumber == nil {
                userLabel.text = "\(assignedUser.name ?? "") - 신탁 계좌를 등록 해주세요"
            } else {
                userLabel.text = "\(assignedUser.name ?? "") - \(assignedUser.bankAccountNumber ?? "")"
            }
        } else {
            if let balance = Globals.userData?.balance {
                moneyLabel.text = "\(balance) 원"
            }
            userLabel.text = "신탁 계좌를 등록 해주세요"
        }
        
        if Globals.userData?.getUserType == .supportAgency || Globals.userData?.getUserType == .volunteer {
            // support agent and volunteer
//            searchFieldView.isHidden = true
        } else {
            // user only
            desiredDateButton.setTitle(Strings.Desired_Date, for: .normal)
//            filterButton.setTitleColor(.PRIMARY_DARK, for: .normal)
            
        }
        
        searchDateButton.tintColor = .SECONDARY_MEDIUM_BLUE
        searchDateButton.backgroundColor = .white
        searchDateButton.shadowAndRoundCorner()
        
        moneyView.shadowAndRoundCorner()
        moneyView.backgroundColor = .PRIMARY_DARK
        
        startDateFilter.setBottomBorder(color: .PRIMARY_DARK)
        startDateFilter.textAlignment = .center
        startDateFilter.setRightViewImage(image: UIImage.init(named: "ic_calendar")!)
        addDatePicker(datePicker: startDatePicker, field: startDateFilter)
        
        endDateFilter.setBottomBorder(color: .PRIMARY_DARK)
        endDateFilter.textAlignment = .center
        endDateFilter.setRightViewImage(image: UIImage.init(named: "ic_calendar")!)
        addDatePicker(datePicker: endDatePicker, field: endDateFilter)
        
        filterTypeButton.setTitleColor(.PRIMARY_DARK, for: .normal)
        
        setupDateFilter()
        
        searchField.setBottomBorder(color: .PRIMARY_DARK)
        searchField.placeholder = Strings.Search
        
        // Strings
        todayButton.setTitle(Strings.Today, for: .normal)
        week1Button.setTitle(Strings.One_Week, for: .normal)
        month1Button.setTitle(Strings.One_Month, for: .normal)
        month6Button.setTitle(Strings.Six_Months, for: .normal)
        filterTypeButton.setTitle(Strings.Newest, for: .normal)
//        filterButton.setTitle(Strings.Newest, for: .normal)
        desiredDateButton.setTitle(Strings.Desired_Date, for: .normal)
        downloadButton.setTitle(Strings.Download, for: .normal)
        
        // Load more indicator
        loadMoreIndicator.startAnimating()
        
        // Pull to refresh indicator
        refreshControl.attributedTitle = NSAttributedString.init(string: Strings.Pull_To_Refresh)
        refreshControl.addTarget(self, action: #selector(refreshBtn), for: .valueChanged)
        transactionList.addSubview(refreshControl)
    }
    
    // MARK: CONFIGURE BINDINGS
    private func configureBindings(){
        startDateFilter.rx.controlEvent([.editingDidBegin])
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.activeDateFilter = startDateFilter
            }).disposed(by: disposeBag)
        
        endDateFilter.rx.controlEvent([.editingDidBegin])
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.activeDateFilter = endDateFilter
            }).disposed(by: disposeBag)
        
        filterTypeButton.rx.tap
            .bind { [unowned self] _ in
                self.toggleFilterType()
            }.disposed(by: disposeBag)
        
//        filterButton.rx.tap
//            .bind { [unowned self] _ in
//                self.toggleFilterType()
//                getTransactions()
//            }.disposed(by: disposeBag)
        
        searchDateButton.rx.tap.bind {
            [unowned self] _ in
            getTransactions()
        }.disposed(by: disposeBag)
        
        searchField.rx.text
            .bind(to: viewModel.userSearchKeyword)
            .disposed(by: disposeBag)
        
        searchField.rx.controlEvent([.editingDidEnd])
            .subscribe(onNext: { [unowned self] _ in
                print("Did end editing search")
                print("Search keyword : \(String(describing: viewModel.userSearchKeyword.value))")
                getTransactions()
            }).disposed(by: disposeBag)
        
        downloadButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                SVProgressHUD.show(withStatus: Strings.Loading)
                viewModel.downloadExcel()
                    .subscribe { url in
                        SVProgressHUD.dismiss()
                        if let urlStr = url {
                            let vc = UIActivityViewController(activityItems: [urlStr], applicationActivities: nil)
                            self.present(vc, animated: true, completion: nil)
                        } else {
                            print("No URL")
                        }
                    } onFailure: { err in
                        self.showSystemErrorAlert(message: err.localizedDescription)
                    } onDisposed: {}
                    .disposed(by: disposeBag)
            }).disposed(by: disposeBag)
        
        viewModel.startFilterDateObservable
            .subscribe(onNext: { date in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd"
                self.startDateFilter.text = formatter.string(from: date)
                self.startDatePicker.date = date
            }).disposed(by: disposeBag)
        
        viewModel.endFilterDateObservable
            .subscribe(onNext: { date in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd"
                self.endDateFilter.text = formatter.string(from: date)
                self.endDatePicker.date = date
            }).disposed(by: disposeBag)
        
        transactionList.register(UINib.init(nibName: "TransactionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: TransactionTableViewCell.mReuseIdentifier)
        
        transactionList.rx.didScroll
            .throttle(.milliseconds(800), scheduler: MainScheduler.asyncInstance)
            .map { return self.transactionList.contentOffset.y }
            .subscribe(onNext: { [unowned self] in
                let maxCapacity = viewModel.transactionItemLimit ?? 15
                let distanceToBottom = transactionList.contentSize.height - $0
                let tableHeight = transactionList.frame.size.height
                if viewModel.transactionListObservable.value.count % maxCapacity == 0 && viewModel.transactionListObservable.value.count != 0 {
                    if distanceToBottom < tableHeight {
                        self.loadMoreIndicator.isHidden = false
                        self.loadMoreIndicator.startAnimating()
                        self.getTransactions(isLoadMore: true)
                    }
                }
            }).disposed(by: disposeBag)
        
        viewModel.transactionListObservable.bind(to: transactionList.rx.items(cellIdentifier: TransactionTableViewCell.mReuseIdentifier, cellType: TransactionTableViewCell.self)) {
            row, item, cell in
            cell.viewModel = item
        }.disposed(by: disposeBag)
    }
    
    // MARK: REFRESH
    @objc private func refreshBtn(){
        if let assignedUser = assignedUserData {
            viewModel.getTransactions(userId: assignedUser.id)
                .subscribe(onCompleted: {
                    self.refreshControl.endRefreshing()
                }) { err in
                    self.showSystemErrorAlert(message: err.localizedDescription)
                } onDisposed: {
                    //
                }
                .disposed(by: disposeBag)
        } else {
            viewModel.getTransactions()
                .subscribe(onCompleted: {
                    self.refreshControl.endRefreshing()
                }) { err in
                    self.showSystemErrorAlert(message: err.localizedDescription)
                } onDisposed: {
                    //
                }
                .disposed(by: disposeBag)
        }
    }
    
    
    private func getTransactions(isLoadMore : Bool = false){
        loadMoreIndicator.startAnimating()
        if let assignedUser = assignedUserData {
            // If this is an assigned user
            viewModel.getTransactions(isLoadMore: isLoadMore, userId: assignedUser.id)
                .subscribe(onCompleted: {
                    self.loadMoreIndicator.stopAnimating()
                    self.loadMoreIndicator.isHidden = true
                }) { err in
                    self.showSystemErrorAlert(message: err.localizedDescription)
                } onDisposed: {
                    //
                }
                .disposed(by: disposeBag)
        } else {
            viewModel.getTransactions(isLoadMore: isLoadMore)
                .subscribe(onCompleted: {
                    self.loadMoreIndicator.stopAnimating()
                    self.loadMoreIndicator.isHidden = true
                }) { err in
                    self.showSystemErrorAlert(message: err.localizedDescription)
                } onDisposed: {
                    //
                }
                .disposed(by: disposeBag)
        }
        
    }
    
    // MARK: SETUP BUTTON
    private func setupButton(){
        filterButtons.forEach {
            $0?.shadowAndRoundCorner()
            if $0 == currentActiveFilter {
                $0?.secondaryBlueStyle()
                if $0 == desiredDateButton {
                    enableDateFilter()
                } else {
                    disableDateFilter()
                }
            } else {
                $0?.secondaryBlueStyleInactive()
            }
            $0?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            $0?.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    private func setupDateFilter(){
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        startDateFilter.text = dateFormatter.string(from: viewModel.startFilterDateObservable.value)
        endDateFilter.text = dateFormatter.string(from: viewModel.endFilterDateObservable.value)
    }
    
    @IBAction func filterButtonTapped(_ sender: DefaultButton) {
        if sender == desiredDateButton {
            if Globals.userData?.getUserType == .user {
                let dateRangePicker = DateRangeBottomSheetController.init()
                dateRangePicker.viewModel = viewModel
                dateRangePicker.onDismiss
                    .subscribe(onNext: { [unowned self] startDate, endDate in
                        // MARK: On Date Range Setup
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy/MM/dd"
                        
                        self.viewModel.startFilterDateObservable.accept(startDate)
                        startDateFilter.text = formatter.string(from: viewModel.startFilterDateObservable.value)
                        self.viewModel.endFilterDateObservable.accept(endDate)
                        endDateFilter.text = formatter.string(from: viewModel.endFilterDateObservable.value)
                        
                        getTransactions()
                    }).disposed(by: disposeBag)
                let bottomSheet = MDCBottomSheetController.init(contentViewController: dateRangePicker)
                self.present(bottomSheet, animated: true, completion: nil)
            }
        }
        currentActiveFilter = sender
        setupButton()
        viewModel.currentFilterMode = FilterMode.init(btn: sender)!
    }
}

// MARK: DATE PICKER
extension TransactionViewController {
    
    func addDatePicker(datePicker : UIDatePicker, field : UITextField){
        datePicker.datePickerMode = .date
        datePicker.locale = .EN
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        doneButton.setTitleTextAttributes([.foregroundColor : UIColor.PRIMARY_DARK], for: .normal)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        cancelButton.setTitleTextAttributes([.foregroundColor : UIColor.PRIMARY_DARK], for: .normal)
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        field.inputAccessoryView = toolbar
        if field == startDateFilter {
            datePicker.date = viewModel.startFilterDateObservable.value
        } else if field == endDateFilter{
            datePicker.date = viewModel.endFilterDateObservable.value
        }
        field.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        switch viewModel.activeDateFilter {
        case startDateFilter:
            viewModel.startFilterDateObservable.accept(startDatePicker.date)
            startDateFilter.text = formatter.string(from: viewModel.startFilterDateObservable.value)
            break
        case endDateFilter:
            viewModel.endFilterDateObservable.accept(endDatePicker.date)
            endDateFilter.text = formatter.string(from: viewModel.endFilterDateObservable.value)
            break
        default:
            break
        }
        
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
}

// MARK: MANUAL FILTER FUNCTIONS

extension TransactionViewController {
    
    private func enableDateFilter(){
        startDateFilter.isEnabled = true
        startDateFilter.alpha = 1
        endDateFilter.isEnabled = true
        endDateFilter.alpha = 1
        filterTypeButton.isEnabled = true
        searchDateButton.isEnabled = true
    }
    
    private func disableDateFilter(){
        startDateFilter.isEnabled = false
        startDateFilter.alpha = 0.5
        endDateFilter.isEnabled = false
        endDateFilter.alpha = 0.5
        filterTypeButton.isEnabled = false
        searchDateButton.isEnabled = false
    }
    
    private func toggleFilterType(){
        
        // Filter button on date pickers
        if filterTypeButton.titleLabel?.text == FilterSort.newest.string {
            viewModel.currentSort = .oldest
            filterTypeButton.setTitle(FilterSort.oldest.string, for: .normal)
        } else {
            viewModel.currentSort = .newest
            filterTypeButton.setTitle(FilterSort.newest.string, for: .normal)
        }
        
        // Filter button on search field
//        if filterButton.titleLabel?.text == FilterSort.newest.string {
//            viewModel.currentSort = .oldest
//            filterButton.setTitle(FilterSort.oldest.string, for: .normal)
//        } else {
//            viewModel.currentSort = .newest
//            filterButton.setTitle(FilterSort.newest.string, for: .normal)
//        }
    }
}

extension TransactionViewController : UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let toViewController = navigationController.transitionCoordinator?.viewController(forKey: .to) else { return }
        
        if toViewController is TransactionListViewController {
            viewModel.currentAssignedUserId = nil
        }
    }
    
}


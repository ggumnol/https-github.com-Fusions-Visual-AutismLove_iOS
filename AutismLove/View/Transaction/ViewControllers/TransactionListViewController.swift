//
//  TransactionListViewController.swift
//  AutismLove
//
//  Created by BobbyPhtr on 12/05/21.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD
import MaterialComponents

enum GroupingType : String, CaseIterable {
    case name = "Name"
    case newestContract = "Newest Contract"
    case oldestContract = "Oldest Contract"
    
    var apiCode : String {
        get {
            switch self {
            case .name:
                return "+name"
            case .newestContract:
                return "-contract_period_start"
            case .oldestContract:
                return "+contract_period_start"
            }
        }
    }
}

class TransactionListViewController: BaseViewController {
    
    var viewModel : TransactionViewModel!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var groupingSettingsButton: DefaultButton!
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: DefaultButton!
    
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var totalHeight: NSLayoutConstraint!
    
    @IBOutlet weak var assignedUserList: UITableView!
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    private var refreshControl = UIRefreshControl()
    
    convenience init(viewModel : TransactionViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureBindings()
        
        viewModel.getAssignedUser()
            .subscribe(onCompleted: {
                self.loadingIndicatorView.stopAnimating()
            }) { err in
                self.showSystemErrorAlert(message: err.localizedDescription)
            } onDisposed: {
                //
            }
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationController()
        navigationTitleLogoImage()
    }
    
    // MARK: CONFIGURE VIEWS
    private func configureViews(){
        if viewModel.currentUserType == .user ||
            viewModel.currentUserType == .volunteer {
            totalHeight.constant = totalHeight.constant - headerHeight.constant
            headerHeight.constant = 0
        }
        groupingSettingsButton.textStyle()
        groupingSettingsButton.tintColor = .PRIMARY_DARK
        configureGroupButton()
        
        searchField.setBottomBorder(color: .PRIMARY_DARK)
        searchField.placeholder = Strings.Search
        searchButton.tintColor = .PRIMARY_DARK
        
        titleLabel.text = Strings.My_Users_Account_Info
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.textColor = .PRIMARY_DARK
        
        // Load more indicator
        loadingIndicatorView.startAnimating()
        
        // Pull to refresh indicator
        refreshControl.attributedTitle = NSAttributedString.init(string: Strings.Pull_To_Refresh)
        refreshControl.addTarget(self, action: #selector(refreshBtn), for: .valueChanged)
        assignedUserList.addSubview(refreshControl)
        assignedUserList.separatorStyle = .none
        
    }
    
    private func configureGroupButton(){
        var btnTitle : String = ""
        if viewModel.isGroupByUsers.value {
            btnTitle += Strings.Grouping_ON
        } else {
            btnTitle += Strings.Grouping_OFF
        }
        
        btnTitle += " | "
        
        switch viewModel.usersOrderType.value {
        case .name:
            btnTitle += Strings.Name
            break
        case .newestContract:
            btnTitle += Strings.Newest_Contract
            break
        case .oldestContract:
            btnTitle += Strings.Oldest_Contract
            break
        }
        
        groupingSettingsButton.setTitle(btnTitle, for: .normal)
    }
    
    // MARK: CONFIGURE BINDINGS
    private func configureBindings(){
        assignedUserList.register(UINib.init(nibName: "UserTransactionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: UserTransactionTableViewCell.mReuseIdentifier)
        assignedUserList.register(UINib.init(nibName: "UserTransactionSectionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: UserTransactionSectionTableViewCell.mReuseIdentifier)
        
        viewModel.assignedUserTransactionsObservableList.subscribe(onNext: { _ in
            self.assignedUserList.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.assignedUserDatasourceObservable.subscribe(onNext: { _ in
            self.assignedUserList.reloadData()
        }).disposed(by: disposeBag)
        
        assignedUserList.delegate = self
        assignedUserList.dataSource = self
        
        groupingSettingsButton.rx.tap
            .bind {
                let vc = ConfigurationBottomSheetViewController.init()
                vc.viewModel = self.viewModel
                let bottomSheet = MDCBottomSheetController.init(contentViewController: vc)
                vc.onDismiss.subscribe(onNext:{ _ in
                    self.refreshBtn()
                }).disposed(by: self.disposeBag)
                self.present(bottomSheet, animated: true, completion: nil)
            }.disposed(by: disposeBag)
        
        viewModel.isGroupByUsers
            .subscribe(onNext:{ bool in
                self.configureGroupButton()
            }).disposed(by: disposeBag)
        
        viewModel.usersOrderType
            .subscribe(onNext: { _ in
                self.configureGroupButton()
            }).disposed(by: disposeBag)
        
        searchField.rx.text
            .bind(to: viewModel.userSearchKeyword)
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .bind {
                self.refreshBtn()
            }.disposed(by: disposeBag)
    }
    
    @objc private func refreshBtn(){
        viewModel.getAssignedUser()
            .subscribe(onCompleted: {
                self.refreshControl.endRefreshing()
                self.loadingIndicatorView.isHidden = true
            }) { err in
                self.showSystemErrorAlert(message: err.localizedDescription)
            } onDisposed: {
                //
            }
            .disposed(by: disposeBag)
    }
}

extension TransactionListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.isGroupByUsers.value {
            return viewModel.assignedUserDatasourceObservable.value.count
        } else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isGroupByUsers.value {
            if viewModel.assignedUserDatasourceObservable.value[section].isExpanded == true {
                return viewModel.assignedUserDatasourceObservable.value[section].userData.count + 1
            } else {
                return 1
            }
        } else {
            return viewModel.assignedUserTransactionsObservableList.value.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isGroupByUsers.value == true {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: UserTransactionSectionTableViewCell.mReuseIdentifier) as! UserTransactionSectionTableViewCell
                cell.model = viewModel.assignedUserDatasourceObservable.value[indexPath.section]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: UserTransactionTableViewCell.mReuseIdentifier) as! UserTransactionTableViewCell
                cell.viewModel = viewModel.assignedUserDatasourceObservable.value[indexPath.section].userData[indexPath.row - 1]
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserTransactionTableViewCell.mReuseIdentifier) as! UserTransactionTableViewCell
            cell.viewModel = viewModel.assignedUserTransactionsObservableList.value[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if viewModel.isGroupByUsers.value {
            if indexPath.row == 0 {
                // first index is title
                var model = viewModel.assignedUserDatasourceObservable.value[indexPath.section]
                model.isExpanded = !model.isExpanded!
                
                viewModel.assignedUserDatasourceObservable.remove(at: indexPath.section)
                viewModel.assignedUserDatasourceObservable.insert(model, at: indexPath.section)
                
                tableView.reloadSections([indexPath.section], with: .automatic)
            } else {
                // the rest is regular cell
                let model = viewModel.assignedUserDatasourceObservable.value[indexPath.section].userData[indexPath.row - 1]
                self.viewModel.currentAssignedUserId = model.assignedUser?.id
                
                let vc = TransactionViewController.init(viewModel: self.viewModel, assignedUserData: model.assignedUser)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            // IF no grouping
            let model = viewModel.assignedUserTransactionsObservableList.value[indexPath.row]
            self.viewModel.currentAssignedUserId = model.assignedUser?.id
            
            let vc = TransactionViewController.init(viewModel: self.viewModel, assignedUserData: model.assignedUser)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

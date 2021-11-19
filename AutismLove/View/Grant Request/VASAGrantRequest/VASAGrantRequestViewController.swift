//
//  VASAGrantRequestViewController.swift
//  AutismLove
//
//  Created by Samuel Krisna on 17/05/21.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class VASAGrantRequestViewController: BaseViewController, UITableViewDelegate {

    @IBOutlet weak var userGrantRequestListLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadMoreIndicator: UIActivityIndicatorView!
    
    var viewModel: GrantRequestViewModel!
    private let disposeBag = DisposeBag()
    
    private var refreshControl = UIRefreshControl()
    
    convenience init(viewModel: GrantRequestViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTableView()
        setupData()
        setupBindings()
    }
    
    func setupView() {
        navigationTitleLogoImage()
        
        userGrantRequestListLabel.text = Strings.Users_Grants_Request_List
        
        refreshControl.attributedTitle = NSAttributedString.init(string: Strings.Pull_To_Refresh)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.backgroundColor = .BACKGROUND_LIGHT_GRAY
        
        loadMoreIndicator.isHidden = true
    }
    
    @objc func refresh() {
        viewModel.getConnectedUser()
            .subscribe(onCompleted: {
                self.refreshControl.endRefreshing()
            }) { err in
                self.showSystemErrorAlert(message: err.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func setupTableView() {
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let customCell = UINib(nibName: "VASAGrantRequestTableViewCell", bundle: nil)
        tableView.register(customCell, forCellReuseIdentifier: "vasaGrantRequestTableViewCell")
    }
    
    func setupData() {
        SVProgressHUD.show()
        
        viewModel.getConnectedUser().subscribe {
            SVProgressHUD.dismiss()
        } onError: { error in
            SVProgressHUD.dismiss()
            self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
        }.disposed(by: disposeBag)
    }
    
    private func setupBindings() {
        viewModel.connectedUsersObservable.bind(to: tableView.rx.items(cellIdentifier: "vasaGrantRequestTableViewCell", cellType: VASAGrantRequestTableViewCell.self)) { row, item, cell in
            cell.setupData(with: item)
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ConnectedUser.self).subscribe { [unowned self] item in
            viewModel.connectedUserData = item
            let vc = VASAGrantRequestListViewController.init(viewModel: viewModel)
            navigationController?.pushViewController(vc, animated: true)
        } onError: { error in
            self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
        }.disposed(by: disposeBag)
    }
}

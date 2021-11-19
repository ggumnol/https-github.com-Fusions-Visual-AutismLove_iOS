//
//  PublicNotificationViewController.swift
//  AutismLove
//
//  Created by Samuel Krisna on 25/04/21.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class PublicNotificationViewController: BaseViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadMoreIndicator: UIActivityIndicatorView!
    
    var viewModel: HomeViewModel!
    private let disposeBag = DisposeBag()
    
    convenience init(viewModel: HomeViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBinding()
        setupData()
    }
    
    func setupData() {
        SVProgressHUD.show()
        viewModel.getAnnouncement(isLoadMore: false).subscribe {
            SVProgressHUD.dismiss()
        } onError: { error in
            SVProgressHUD.dismiss()
            self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
        }.disposed(by: disposeBag)
    }
    
    private func setupView() {
        navigationTitleLogoImage()
        
        loadMoreIndicator.isHidden = true
        
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let customCell = UINib(nibName: "PublicNotificationTableViewCell", bundle: nil)
        tableView.register(customCell, forCellReuseIdentifier: "publicNotificationTableViewCell")
    }
    
    func setupBinding() {
        viewModel.announcementObservable.bind(to: tableView.rx.items(cellIdentifier: "publicNotificationTableViewCell", cellType: PublicNotificationTableViewCell.self)) { row, item, cell in
            cell.setupData(with: item)
        }.disposed(by: disposeBag)
    }
}

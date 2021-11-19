//
//  VolunteerAndSupportAgencyHomeViewController.swift
//  AutismLove
//
//  Created by Samuel Krisna on 30/04/21.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class VolunteerAndSupportAgencyHomeViewController: BaseViewController, UITableViewDelegate  {

    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usersTableView: UITableView!
    
    var viewModel: HomeViewModel!
    private let disposeBag = DisposeBag()
    
    convenience init(viewModel: HomeViewModel) {
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
        
        titleView.backgroundColor = UIColor.PRIMARY_DARK
        titleLabel.textColor = .white
        titleLabel.text = Strings.My_User_Information
        
        // Left
        let leftImage = UIImage(named: "ic_public_notification")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImage, style: .plain, target: self, action: #selector(publicNotificationTapped))
        
        // Right
        let rightImage = UIImage(named: "ic_notification")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage, style: .plain, target: self, action: #selector(notificationTapped))
    }

    @objc override func publicNotificationTapped() {
        navigationController?.pushViewController(PublicNotificationViewController.init(viewModel: viewModel), animated: true)
    }
    
    @objc override func notificationTapped() {
        navigationController?.pushViewController(NotificationViewController.init(viewModel: viewModel), animated: true)
}
    
    func setupTableView() {
        usersTableView.delegate = nil
        usersTableView.dataSource = nil
        usersTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let customCell = UINib(nibName: "MyUserTableViewCell", bundle: nil)
        usersTableView.register(customCell, forCellReuseIdentifier: "myUserTableViewCell")
    }
    
    func setupData() {
        SVProgressHUD.show()
        viewModel.getAssignedUser().subscribe {
            SVProgressHUD.dismiss()
        } onError: { error in
            self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
        }.disposed(by: disposeBag)
    }
    
    func setupBindings() {
        viewModel.assignedUsersObservable.bind(to: usersTableView.rx.items(cellIdentifier: "myUserTableViewCell", cellType: MyUserTableViewCell.self)) { row, item, cell in
            cell.setupData(with: item)
        }.disposed(by: disposeBag)
        
        usersTableView.rx.modelSelected(AssignedUserData.self).subscribe { [unowned self] item in
            let vc = VASAHomeUserStatusViewController.init(viewModel: viewModel)
            viewModel.assignedUser = item
            navigationController?.pushViewController(vc, animated: true)
        } onError: { error in
            self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
        }.disposed(by: disposeBag)
    }
}

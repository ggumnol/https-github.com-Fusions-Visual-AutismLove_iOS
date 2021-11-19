//
//  VASAGrantRequestListViewController.swift
//  AutismLove
//
//  Created by Samuel Krisna on 17/05/21.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class VASAGrantRequestListViewController: BaseViewController, UITableViewDelegate {

    @IBOutlet weak var grantsRequestListLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var downloadButton: DefaultButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewGrantRequestButton: DefaultButton!
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
        setupData()
        setupBindings()
    }
    
    private func setupView() {
        grantsRequestListLabel.text = Strings.Grant_Request_List
        
        tableView.backgroundColor = .BACKGROUND_LIGHT_GRAY
        containerView.backgroundColor = .BACKGROUND_LIGHT_GRAY
        
        downloadButton.setTitle(Strings.Download, for: .normal)
        downloadButton.linkStyle()
        
        navigationTitleLogoImage()
        
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        loadMoreIndicator.isHidden = true
        refreshControl.attributedTitle = NSAttributedString.init(string: Strings.Pull_To_Refresh)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        let customCell = UINib(nibName: "GrantRequestTableViewCell", bundle: nil)
        tableView.register(customCell, forCellReuseIdentifier: "grantRequestTableViewCell")
        
        addNewGrantRequestButton.setTitle(Strings.Add_New_Grant_Request, for: .normal)
        addNewGrantRequestButton.primaryBlueStyle()
    }
    
    func setupData() {
        SVProgressHUD.show()
        
        viewModel.grantRequestIdObservable.accept(viewModel.connectedUserData._id)
        
        usernameLabel.text = viewModel.connectedUserData.name
        
        viewModel.getGrantRequestData(isLoadMore: false, userId: viewModel.connectedUserData._id).subscribe {
            SVProgressHUD.dismiss()
        } onError: { error in
            SVProgressHUD.dismiss()
            self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
        }.disposed(by: disposeBag)
    }
    
    private func setupBindings() {
        viewModel.grantRequestListObservable.bind(to: tableView.rx.items(cellIdentifier: "grantRequestTableViewCell", cellType: GrantRequestTableViewCell.self)) { [self] row, item, cell in
            cell.no = viewModel.grantRequestItemTotalValue! - row
            cell.setupData(with: item, viewModel: viewModel)
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(GrantRequestData.self).subscribe { [unowned self] item in
            viewModel.grantRequestIdObservable.accept(item._id)
            viewModel.statusObservable.accept(item.status)
            if item.rejected_by.count > 0 {
                viewModel.rejectedReasonObservable.accept(item.rejected_by[0]?.rejected_reason)
            }
            viewModel.requestReasonObservable.accept(item.requestReason)
            viewModel.usagesObservable.accept(item.usages)
            viewModel.grantDateObservable.accept(item.grantDate)
            viewModel.imageOfProofObservable.accept(item.imagesOfProof!)
            viewModel.requesterNameObservable.accept(item.requester?.name)
            viewModel.isUsageFilledObservable.accept(true)
            viewModel.seenBy.append(contentsOf: item.seen_by!)
            
            viewModel.grantRequestData = item
            
            let vc = GrantRequestDetailViewController.init(viewModel: viewModel)
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        } onError: { error in
            self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
        }.disposed(by: disposeBag)
        
        tableView.rx.didScroll
            .throttle(.milliseconds(600), scheduler: MainScheduler.asyncInstance)
            .map { return self.tableView.contentOffset.y }
            .subscribe(onNext: { [unowned self] in
                let maxCapacity = viewModel.grantRequestItemLimit ?? 15
                let distanceToBottom = tableView.contentSize.height - $0
                let tableHeight = tableView.frame.size.height
                if viewModel.grantRequestListObservable.value.count % maxCapacity == 0 && viewModel.grantRequestListObservable.value.count != 0 {
                    if distanceToBottom < tableHeight {
                        self.loadMoreIndicator.isHidden = false
                        self.loadMoreIndicator.startAnimating()
                        self.getGrantRequest(isLoadMore: true)
                    }
                }
            }).disposed(by: disposeBag)
        
        downloadButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            SVProgressHUD.show(withStatus: Strings.Loading)
            viewModel.downloadPDF(userId: viewModel.connectedUserData._id).subscribe { url in
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
        }).disposed(by: disposeBag)
    }
    
    @objc func refresh() {
        viewModel.getGrantRequestData(isLoadMore: false, userId: viewModel.connectedUserData._id)
            .subscribe(onCompleted: {
                self.refreshControl.endRefreshing()
            }) { err in
                self.showSystemErrorAlert(message: err.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    private func getGrantRequest(isLoadMore : Bool = false){
        viewModel.getGrantRequestData(isLoadMore: isLoadMore, userId: viewModel.connectedUserData._id)
            .subscribe(onCompleted: {
                self.loadMoreIndicator.stopAnimating()
                self.loadMoreIndicator.isHidden = true
            }) { err in
                self.showSystemErrorAlert(message: err.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    @IBAction func downloadTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func addNewGrantRequestTapped(_ sender: Any) {
        let vc = AddNewFormViewController.init(viewModel: GrantRequestViewModel.init())
        vc.viewModel.connectedUserData = viewModel.connectedUserData
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension VASAGrantRequestListViewController: GrantRequestDelegate {
    func refreshData() {
        setupData()
    }
}

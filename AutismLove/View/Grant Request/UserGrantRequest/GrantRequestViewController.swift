//
//  GrantRequestViewController.swift
//  AutismLove
//
//  Created by Samuel Krisna on 25/04/21.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

protocol GrantRequestDelegate: AnyObject {
    func refreshData()
}

class GrantRequestViewController: BaseViewController, UITableViewDelegate {
    
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadMoreIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var addNewGrantRequestButton: DefaultButton!
    @IBOutlet weak var downloadRequestListsButton: DefaultButton!
    
    private let editGrantRequestViewController = EditGrantRequestViewController()
    
    var signatureVC = SignatureViewController()
    var viewModel: GrantRequestViewModel!
    private let disposeBag = DisposeBag()
    
    private var refreshControl = UIRefreshControl()
    
    convenience init(viewModel: GrantRequestViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupView()
        setupData()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        showNavigationController()
        
        if viewModel.isRefresh == true {
            setupData()
            viewModel.isRefresh = false
        }
    }
    
    func setupView() {
        navigationTitleLogoImage()
        
        tableView.backgroundColor = .BACKGROUND_LIGHT_GRAY
        
        pageTitle.text = Strings.Grant_Request_List
        subtitleLabel.text = Strings.I_Need_More_Money
        
        refreshControl.attributedTitle = NSAttributedString.init(string: Strings.Pull_To_Refresh)
        refreshControl.addTarget(self, action: #selector(refreshMore), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        // Add new
        addNewGrantRequestButton.setTitle(Strings.Add_New_Grant_Request.localized(), for: .normal)
        addNewGrantRequestButton.primaryBlueStyle()
        
        // Download
        downloadRequestListsButton.setTitle(Strings.Download_Request_Lists.localized(), for: .normal)
        downloadRequestListsButton.whiteBlueStyle()
        
        loadMoreIndicator.isHidden = true
    }
    
    @objc func refreshMore() {
        viewModel.getGrantRequestData()
            .subscribe(onCompleted: {
                self.refreshControl.endRefreshing()
            }) { err in
                self.showSystemErrorAlert(message: err.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let customCell = UINib(nibName: "GrantRequestTableViewCell", bundle: nil)
        tableView.register(customCell, forCellReuseIdentifier: "grantRequestTableViewCell")
    }
    
    func setupData() {
        signatureVC.delegate = self
        
        SVProgressHUD.show()
        viewModel.getGrantRequestData().subscribe {
            SVProgressHUD.dismiss()
        } onError: { error in
            SVProgressHUD.dismiss()
            self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
        }.disposed(by: disposeBag)
    }
    
    @objc func connected(sender: UIButton) {
        let vc = EditGrantRequestViewController.init(viewModel: viewModel)
        var idx = 0
        viewModel.grantRequestListObservable.value.forEach { data in
            if idx == sender.tag {
                viewModel.grantRequestIdObservable.accept(data._id)
                viewModel.statusObservable.accept(data.status)
                if data.rejected_by.count > 0 {
                    viewModel.rejectedReasonObservable.accept(data.rejected_by[0]?.rejected_reason)
                }
                viewModel.requestReasonObservable.accept(data.requestReason)
                viewModel.usagesObservable.accept(data.usages)
                viewModel.grantDateObservable.accept(data.grantDate)
                viewModel.imageOfProofObservable.accept(data.imagesOfProof!)
                viewModel.requesterIdObservable.accept(data.requester?._id)
                viewModel.requesterNameObservable.accept(data.requester?.name)
                viewModel.isUsageFilledObservable.accept(true)
                viewModel.seenBy.append(contentsOf: data.seen_by!)
                
                viewModel.grantRequestData = data
                
                viewModel.isEditable = false
            }
            idx += 1
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupBindings() {
        viewModel.grantRequestListObservable.bind(to: tableView.rx.items(cellIdentifier: "grantRequestTableViewCell", cellType: GrantRequestTableViewCell.self)) { [self] row, item, cell in
            cell.no = viewModel.grantRequestItemTotalValue! - row
            cell.setupData(with: item, viewModel: viewModel)
            
            cell.uploadProofButton.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
            cell.uploadProofButton.tag = row
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
            viewModel.requesterIdObservable.accept(item.requester?._id)
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
            .throttle(.milliseconds(800), scheduler: MainScheduler.asyncInstance)
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
        
        // Download
        downloadRequestListsButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            SVProgressHUD.show(withStatus: Strings.Loading)
            viewModel.downloadPDF(userId: nil).subscribe { url in
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
    
    private func getGrantRequest(isLoadMore: Bool = false) {
        viewModel.getGrantRequestData(isLoadMore: isLoadMore)
            .subscribe(onCompleted: {
                self.loadMoreIndicator.stopAnimating()
                self.loadMoreIndicator.isHidden = true
            }) { err in
                self.showSystemErrorAlert(message: err.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    @IBAction func addNewTapped(_ sender: Any) {
        navigationController?.pushViewController(AddNewFormViewController.init(viewModel: GrantRequestViewModel.init()), animated: true)
    }
}

extension GrantRequestViewController: GrantRequestDelegate {
    func refreshData() {
        setupData()
    }
}

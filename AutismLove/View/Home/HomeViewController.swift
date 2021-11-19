//
//  HomeViewController.swift
//  AutismLove
//
//  Created by Samuel Krisna on 25/04/21.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class HomeViewController: BaseViewController {

    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var balanceView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var bankAccountNumberLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    var viewModel: HomeViewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    convenience init(viewModel: HomeViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupView()
        setupBindings()
        
        print("Locale : \(String(describing: Locale.current.regionCode))")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showNavigationController()
        setupData()
    }
    
    func setupNavigation() {
        navigationTitleLogoImage()
        
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
    
    func setupView() {
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.text = Strings.My_Trust_Fund_Property
        subtitleLabel.text = Strings.Money_I_Entrusted
        
        balanceView.roundCorners(radius: 7)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.bannerTapped(_:)))
        bannerView.addGestureRecognizer(tap)
    }
    
    func setupData() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        formatter.locale = Locale(identifier: "ko_KR")
        let number = viewModel.userData?.balance
        let spelledOutNumber = formatter.string(for: NSNumber(integerLiteral: number!))!
        
        if viewModel.userData?.bankName != nil && viewModel.userData?.bankAccountNumber != nil {
            bankNameLabel.text = viewModel.userData?.bankName
            bankAccountNumberLabel.text = viewModel.userData?.bankAccountNumber
        } else {
            bankNameLabel.text = "신탁 계좌를 등록 해주세요"
        }
        
        balanceLabel.text = String(viewModel.userData!.balance!.withSeparator(separator: ",")) + " 원"
        amountLabel.text = spelledOutNumber + " 원"
    }
    
    func setupBindings() {
        refreshButton.rx.tap.bind { [unowned self] in refreshUserData() }.disposed(by: disposeBag)
    }
    
    func refreshUserData() {
        SVProgressHUD.show()
        viewModel.refreshUserData().subscribe(onCompleted: {
            SVProgressHUD.dismiss()
        }, onError: { e in
            SVProgressHUD.dismiss()
            print("On Error : \(e.localizedDescription)")
            self.showDefaultDialog(message: "\(e.localizedDescription)", onOkAction: nil)
        })
        .disposed(by: disposeBag)
    }
    
    @objc func bannerTapped(_ sender: UITapGestureRecognizer? = nil) {
        tabBarController?.selectedIndex = 1
    }
}

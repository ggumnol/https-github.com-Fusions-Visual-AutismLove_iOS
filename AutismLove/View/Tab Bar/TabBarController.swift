//
//  TabBarController.swift
//  AutismLove
//
//  Created by Samuel Krisna on 24/04/21.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInit()
        setupVCs()
    }
    
    func setupInit() {
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        UITabBar.appearance().backgroundColor = .white
        tabBar.tintColor = .label
        tabBar.layer.borderWidth = 0.3
        tabBar.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 6
        tabBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tabBar.layer.shadowOpacity = 0.2
    }
    
    func setupVCs() {
        //
        let ic_home = UIImage(named: "ic_home")
        let ic_transaction = UIImage(named: "ic_transaction")
        let ic_grant_request = UIImage(named: "ic_grant_request")
        let ic_messaging = UIImage(named: "ic_messaging")
        let ic_my_page = UIImage(named: "ic_my_page")
        
        var homeVC : UIViewController!
        var transactionVC : UIViewController!
        var grantRequestVC : UIViewController!
        var myPageVC : UIViewController!
        
        if Globals.userData?.getUserType == .user {
            homeVC = HomeViewController()
            transactionVC = TransactionViewController.init(viewModel: TransactionViewModel())
            grantRequestVC = GrantRequestViewController.init(viewModel: GrantRequestViewModel())
            myPageVC = MyPageViewController.init()
        } else {
            homeVC = VolunteerAndSupportAgencyHomeViewController.init(viewModel: HomeViewModel())
            transactionVC = TransactionListViewController.init(viewModel: TransactionViewModel())
            grantRequestVC = VASAGrantRequestViewController.init(viewModel: GrantRequestViewModel())
            myPageVC = UserInformationViewController.init()
        }
        
        viewControllers = [
            generateNavController(vc: homeVC, title: Strings.Home, image: ic_home!),
            generateNavController(vc: transactionVC, title: Strings.Transaction, image: ic_transaction!),
            generateNavController(vc: grantRequestVC, title: Strings.Grant_Request, image: ic_grant_request!),
            generateNavController(vc: MessagingViewController.init(viewModel: MessagingViewModel()), title: Strings.Messaging, image: ic_messaging!),
            generateNavController(vc: myPageVC, title: Strings.My_Page, image: ic_my_page!)
        ]
    }
    
    fileprivate func generateNavController(vc: UIViewController, title: String, image: UIImage) -> UIViewController {
        vc.navigationItem.title = title
        
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image.withRenderingMode(.alwaysOriginal)
        return navController
    }
}

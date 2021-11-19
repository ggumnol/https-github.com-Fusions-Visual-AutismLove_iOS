//
//  MyPageViewController.swift
//  AutismLove
//
//  Created by Samuel Krisna on 25/04/21.
//

import UIKit

class MyPageViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var checkDocumentsView: UIView!
    @IBOutlet weak var checkDocumentsLabel: UILabel!
    
    @IBOutlet weak var userInformationView: UIView!
    @IBOutlet weak var userInformationLabel: UILabel!
    
    lazy var menuView = [checkDocumentsView, userInformationView]
    lazy var menuLabel = [checkDocumentsLabel, userInformationLabel]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showNavigationController()
        navigationTitleLogoImage()
    }
    
    private func configureView(){
        menuView.forEach {
            $0?.backgroundColor = .white
            $0?.shadowAndRoundCorner()
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(onMenuTapped(_:)))
            $0?.addGestureRecognizer(tap)
        }
        
        menuLabel.forEach {
            $0?.textColor = .PRIMARY_DARK
            $0?.font = UIFont.boldSystemFont(ofSize: 14)
        }
        
        checkDocumentsLabel.text = Strings.Check_My_Documents
        userInformationLabel.text = Strings.User_Information
    }
    
    @objc private func onMenuTapped(_ sender : UITapGestureRecognizer){
        switch sender.view {
        case checkDocumentsView:
            let vc = CheckDocumentsViewController.init()
            navigationController?.pushViewController(vc, animated: true)
            break
        case userInformationView:
            let vc = UserInformationViewController.init()
            navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }

}

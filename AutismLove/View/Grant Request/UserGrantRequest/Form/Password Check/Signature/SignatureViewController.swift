//
//  SignatureViewController.swift
//  AutismLove
//
//  Created by Samuel Krisna on 27/04/21.
//

import UIKit
import SwiftSignatureView
import RxSwift
import RxCocoa
import SVProgressHUD

class SignatureViewController: BaseViewController {

    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var signatureView: SwiftSignatureView!
    @IBOutlet weak var rewriteButton: DefaultButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var finishButton: DefaultButton!
    
    weak var delegate: GrantRequestDelegate?
    
    var viewModel: GrantRequestViewModel!
    private let disposeBag = DisposeBag()
    
    let imageUI = UIImage()
    
    convenience init(viewModel: GrantRequestViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupBinding()
    }
    
    private func setupView() {
        pageTitle.text = Strings.Signature
        rewriteButton.setTitle(Strings.Rewrite, for: .normal)
        descriptionLabel.text = Strings.Signature_Description
        finishButton.setTitle(Strings.Finish, for: .normal)
        
        view.backgroundColor = .BACKGROUND_LIGHT_GRAY
        containerView.backgroundColor = .BACKGROUND_LIGHT_GRAY
        
        rewriteButton.linkStyle()
        
        signatureView.roundCorners(radius: 7)
        
        descriptionLabel.textColor = .SECONDARY_MEDIUM_BLUE
        
        finishButton.primaryBlueStyle()
    }
    
    func setupBinding() {
        finishButton.rx.tap.bind { [unowned self] in
            uploadSignature()
        }.disposed(by: disposeBag)
    }
    
    func uploadSignature() {
        SVProgressHUD.show()
        if signatureView.getCroppedSignature() == nil {
            self.showDefaultDialog(message: "Sign first!", onOkAction: nil)
        } else {
            viewModel.uploadSignature(image: signatureView.getCroppedSignature()!).subscribe {  [unowned self] observer  in
                SVProgressHUD.dismiss()
                viewModel.signaturePathObservable.accept(observer.data?.path)
                createGrantRequest()
            } onError: { error in
                SVProgressHUD.dismiss()
                self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
            }.disposed(by: disposeBag)
        }
    }
    
    func createGrantRequest() {
        SVProgressHUD.show()
        viewModel.createGrantRequest().subscribe {  [unowned self] observer  in
            SVProgressHUD.dismiss()
            delegate?.refreshData()
            navigationController?.popToRootViewController(animated: true)
        } onError: { error in
            SVProgressHUD.dismiss()
            self.showDefaultDialog(message: error.localizedDescription, onOkAction: nil)
        }.disposed(by: disposeBag)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rewriteTapped(_ sender: Any) {
        signatureView.clear()
    }
}

//
//  RecoverIDResultVC.swift
//  AutismLove
//
//  Created by BobbyPhtr on 28/04/21.
//

import UIKit
import RxCocoa
import RxSwift

class RecoverIDResultVC : BaseViewController {

    var viewModel : RecoverIDResultViewModel!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var backButton: DefaultButton!
    
    @IBOutlet weak var recoverIdTitle: UILabel!
    @IBOutlet weak var recoverIdSubtitle: UILabel!
    
    @IBOutlet weak var confirmButton: DefaultButton!
    
    convenience init(viewModel : RecoverIDResultViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureBindings()
    }


    private func configureView() {
        recoverIdTitle.textColor = .SECONDARY_MEDIUM_BLUE
        
        recoverIdTitle.text = Strings.ID
        recoverIdSubtitle.text = Strings.Your_ID_Is + "abcd@abc.com"
        
        confirmButton.setTitle(Strings.Return_To_Login, for: .normal)
        confirmButton.primaryBlueStyle()
    }
    
    private func configureBindings(){
        viewModel.recoveredId
            .bind(to: recoverIdSubtitle.rx.text)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .bind { [unowned self] in
                self.navigationController?.popToRootViewController(animated: true)
            }.disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind { [unowned self] in
                self.navigationController?.popToRootViewController(animated: true)
            }.disposed(by: disposeBag)
    }

}

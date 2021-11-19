//
//  SignUpChooseUserType.swift
//  AutismLove
//
//  Created by BobbyPhtr on 26/04/21.
//

import UIKit
import M13Checkbox
import RxSwift
import RxCocoa
import TPKeyboardAvoidingSwift

class SignUpChooseUserTypeVC: BaseViewController {
    
    var viewModel : SignUpViewModel?
    private let disposeBag = DisposeBag()

    @IBOutlet weak var signUpTitle: UILabel!
    @IBOutlet weak var signUpSubtitle: UILabel!
    
    @IBOutlet weak var userRadioView: UIView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userRadioBox: M13Checkbox!
    
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    
    @IBOutlet weak var volunteerRadioView: UIView!
    @IBOutlet weak var volunteerRadioBox: M13Checkbox!
    @IBOutlet weak var volunteerLabel: UILabel!
    
    @IBOutlet weak var supportAgencyRadioView: UIView!
    @IBOutlet weak var supportAgencyLabel: UILabel!
    @IBOutlet weak var supportRadioBox: M13Checkbox!
    
    @IBOutlet weak var signUpButton: DefaultButton!
    
    convenience init(viewModel : SignUpViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        configureBindings()
    }

    private func configureViews() {
        signUpTitle.textColor = .PRIMARY_DARK
        signUpTitle.text = Strings.Sign_Up
        signUpSubtitle.text = Strings.Sign_Up_Subtitle
        userLabel.text = Strings.User
        volunteerLabel.text = Strings.Volunteer
        supportAgencyLabel.text = Strings.Support_Agency
        
        [userRadioView, volunteerRadioView, supportAgencyRadioView].forEach {
            $0?.shadowAndRoundCorner()
            $0?.layer.borderWidth = 2.0
            $0?.layer.borderColor = UIColor.SECONDARY_LIGHT_BLUE.cgColor
            $0?.backgroundColor = .white
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(onRadioButtonTapped(_:)))
            $0?.addGestureRecognizer(tapGesture)
        }
        
        [userLabel, volunteerLabel, supportAgencyLabel].forEach {
            $0?.font = UIFont.boldSystemFont(ofSize: 14)
            $0?.textColor = .SECONDARY_MEDIUM_BLUE
        }
        
        [userRadioBox, volunteerRadioBox, supportRadioBox].forEach {
            $0?.boxType = .circle
            $0?.markType = .checkmark
            $0?.stateChangeAnimation = .fill
            $0?.secondaryTintColor = .SECONDARY_LIGHT_BLUE
            $0?.isUserInteractionEnabled = false
        }
        
        signUpButton.primaryBlueStyle()
        signUpButton.setTitle(Strings.Next, for: .normal)
        
    }
    
    private func configureBindings(){
        viewModel?.currentUserTypeObservable
            .map { $0 != nil }
            .do(onNext: {
                print("Current User Type Observable is \($0)")
            })
            .bind(to: signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    @objc private func onRadioButtonTapped(_ sender : UITapGestureRecognizer){
        resetRadios()
        if sender.view == userRadioView {
            userRadioBox.setCheckState(.checked, animated: true)
            viewModel?.currentUserTypeObservable.accept(UserType.user)
        } else if sender.view == volunteerRadioView {
            volunteerRadioBox.setCheckState(.checked, animated: true)
            viewModel?.currentUserTypeObservable.accept(UserType.volunteer)
        } else if sender.view == supportAgencyRadioView {
            supportRadioBox.setCheckState(.checked, animated: true)
            viewModel?.currentUserTypeObservable.accept(UserType.supportAgency)
        }
        toggleBorderColor(view: sender.view)
    }
    
    private func toggleBorderColor(view : UIView?){
        if view?.layer.borderColor == UIColor.SECONDARY_LIGHT_BLUE.cgColor {
            view?.animateBorderColor(toColor: UIColor.SECONDARY_MEDIUM_BLUE, duration: 0.15)
        } else {
            view?.animateBorderColor(toColor: UIColor.SECONDARY_LIGHT_BLUE, duration: 0.15)
        }
    }
    
    private func resetRadios(){
        [userRadioView, volunteerRadioView, supportAgencyRadioView].forEach {
            $0?.animateBorderColor(toColor: .SECONDARY_LIGHT_BLUE, duration: 0.15)
        }
        
        [userRadioBox, volunteerRadioBox, supportRadioBox].forEach {
            $0?.setCheckState(.unchecked, animated: true)
        }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        guard let vm = viewModel else {
            print("Warning, SignUpViewModel is nil, will not proceed to the next part.")
            return
        }
        let vc = SignUpAgreementVC.init(viewModel: vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

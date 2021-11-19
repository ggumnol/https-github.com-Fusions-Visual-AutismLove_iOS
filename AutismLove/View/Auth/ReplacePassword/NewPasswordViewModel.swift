//
//  NewPasswordViewModel.swift
//  AutismLove
//
//  Created by BobbyPhtr on 03/05/21.
//

import Foundation
import RxSwift
import RxCocoa

class NewPasswordViewModel {
    
    var resetPasswordToken : String!
    
    private let disposeBag = DisposeBag()
    
    var tempPasswordObservable = BehaviorRelay<String?>.init(value: nil)
    var confirmedPasswordObservable = BehaviorRelay<String?>.init(value: nil)
    
    let formValidator = FormValidator.init()
    
    init(resetPasswordToken : String){
        self.resetPasswordToken = resetPasswordToken
    }
    
    func validate()->Observable<Bool>{
        return Observable.create { [unowned self] (observer) -> Disposable in
            if let err = self.formValidator.validate(text: self.tempPasswordObservable.value, with: [.notEmpty]) {
                observer.onError(err)
            } else if let err = self.formValidator.validate(text: self.confirmedPasswordObservable.value, with: [.notEmpty]) {
                observer.onError(err)
            }
            if tempPasswordObservable.value == confirmedPasswordObservable.value {
                observer.onNext(true)
            } else {
                observer.onError(FormError.passwordIsNotValid(msg: Strings.Password_Is_Not_The_Same))
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func submitNewPassword()->Completable{
        return Completable.create { (event) -> Disposable in
            print("Send New Password to the Server")
            AuthService.replacePassword(reset_token: self.resetPasswordToken, newPassword: self.confirmedPasswordObservable.value!)
                .subscribe(onNext: { response in
                    if response.success == true {
                        event(.completed)
                    } else {
                        event(.error(GeneralError.errorWithMessage(message: response.message!)))
                    }
                    
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}

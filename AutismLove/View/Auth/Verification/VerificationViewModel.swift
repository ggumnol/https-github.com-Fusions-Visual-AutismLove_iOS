//
//  VerificationViewModel.swift
//  AutismLove
//
//  Created by BobbyPhtr on 03/05/21.
//

import Foundation
import RxCocoa
import RxSwift
import FirebaseAuth
import SVProgressHUD

class VerificationViewModel {
    
    private let disposeBag = DisposeBag()
    
    var currentVerificationId = ""
    
    // MARK: OBSERVABLE
    let idObservable = BehaviorRelay<String?>.init(value: nil)
    let mobileNumberObservable = BehaviorRelay<String?>.init(value: nil)
    let verificationNumberObservable = BehaviorRelay<String?>.init(value: nil)
    
    let formValidator = FormValidator.init()
    
    func validateMobileNumber()->FormError?{
        guard let num = mobileNumberObservable.value else { return FormError.fieldIsEmpty}
        if let err = formValidator.validate(text: num, with: [.notEmpty, .validPhone]) {
            return err
        }
        return nil
    }
    
    //    func sendVerificationCode()->Observable<Response<NoData>> {
    //        return Observable.create { [unowned self] (observer) -> Disposable in
    //            if let err = self.formValidator.validate(text: self.mobileNumberObservable.value, with: [.notEmpty]) {
    //                observer.onError(err)
    //            } else{
    //                // Send verification to phone number
    //                AuthService.sendOTPToPhone(phoneNum: mobileNumberObservable.value!)
    //                    .subscribe(onNext: { response in
    //                        observer.onNext(response)
    //                        observer.onCompleted()
    //                    })
    //                    .disposed(by: disposeBag)
    //            }
    //            return Disposables.create()
    //        }
    //    }
    
    func sendVerificationCode(completion: @escaping(_ message: String?,_ error: String?) -> Void) {
        var phoneNumber = ""
        
        var originMobileNumber = mobileNumberObservable.value!
        originMobileNumber.remove(at: originMobileNumber.startIndex)
        
        if Locale.current.regionCode == "KR" {
            phoneNumber = "+82\(originMobileNumber)"
        } else if Locale.current.regionCode == "ID" {
            phoneNumber = "+62\(originMobileNumber)"
        }
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error.localizedDescription)
                return
            }
            
            print("Verification Id : \(String(describing: verificationID))")
            self.currentVerificationId = verificationID!
            completion(verificationID, nil)
        }
    }
    
    func verifyToServerForID()->Observable<Response<NoData>>{
        return AuthService.checkEmail(email: idObservable.value!, action: "REPLACE_PASSWORD")
    }
    
    func verifyToServerForRecoverID()->Observable<Response<VerifyOtpDataRecoverID>>{
        return Observable.create { [unowned self] (observer) -> Disposable in
            if let err = self.formValidator.validate(text: self.verificationNumberObservable.value, with: [.notEmpty]) {
                observer.onError(err)
            } else {
                print("Send \(self.verificationNumberObservable.value!) to the server")
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: currentVerificationId, verificationCode: verificationNumberObservable.value!)
                
                Auth.auth().signIn(with: credential) { authResult, error in
                    Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { idToken, error in
                        print("ID Token : \(String(describing: idToken))")
                        AuthService.verifyOTPforRecoverID(otpCode: idToken!)
                            .subscribe(onNext: { response in
                                observer.onNext(response)
                                observer.onCompleted()
                            }).disposed(by: disposeBag)
                    })
                }
            }
            return Disposables.create()
        }
    }
    
    func verifyToServerForResetPassword()->Observable<Response<VerifyOtpResetPasswordData>>{
        return Observable.create { [unowned self] (observer) -> Disposable in
            if let err = self.formValidator.validate(text: self.verificationNumberObservable.value, with: [.notEmpty]) {
                observer.onError(err)
            } else {
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: currentVerificationId, verificationCode: verificationNumberObservable.value!)
                
                Auth.auth().signIn(with: credential) { authResult, error in
                    Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { idToken, error in
                        print("ID Token : \(String(describing: idToken))")
                        AuthService.verifyOTPforReplacePassword(otpCode: idToken!)
                            .subscribe(onNext: { response in
                                observer.onNext(response)
                                observer.onCompleted()
                            }).disposed(by: disposeBag)
                    })
                }
            }
            return Disposables.create()
        }
    }
}

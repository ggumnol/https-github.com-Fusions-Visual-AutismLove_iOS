//
//  SignUpViewModel.swift
//  AutismLove
//
//  Created by BobbyPhtr on 01/05/21.
//

import Foundation
import RxSwift
import RxCocoa


class SignUpViewModel {
    
    let formValidator = FormValidator.init()
    private let disposeBag = DisposeBag()
    
    // MARK: OBSERVABLES
    var currentUserTypeObservable = BehaviorRelay<UserType?>.init(value: nil)
    var agreeToAllRequiredAgreementsObservable = BehaviorRelay<Bool>.init(value: false)
    
    // First Form
    var idObservable = BehaviorRelay<String?>.init(value: nil)
    var tempPasswordObservable = BehaviorRelay<String?>.init(value: nil)
    var confirmedPasswordObservable = BehaviorRelay<String?>.init(value: nil)
    
    // Second Form
    var nameObsevable = BehaviorRelay<String?>.init(value: nil)
    var birthdateObservable = BehaviorRelay<String?>.init(value: nil)
    var contactNumberObservable = BehaviorRelay<String?>.init(value: nil)
    var jobTitleObservable = BehaviorRelay<String?>.init(value: nil)
    var supportAgencyObservable = BehaviorRelay<String?>.init(value: nil)
    
    
    func getDocuments(agreementType : AgreementType)->URL{
        switch agreementType {
        case .privateDataCollection:
            return Bundle.main.url(forResource: "Sample", withExtension: "pdf")!
        case .pushNotification:
            return Bundle.main.url(forResource: "Sample", withExtension: "pdf")!
        case .userSignUp:
            return Bundle.main.url(forResource: "Sample", withExtension: "pdf")!
        }
    }
    
    func doVerifyEmail()->Observable<Response<NoData>>{
        return AuthService.checkEmail(email: idObservable.value!, action: "REGISTER")
    }
    
    func doRegistration()->Observable<Response<RegisterData>>{
        return Observable.create { [unowned self] (observer) -> Disposable in
            if let type = currentUserTypeObservable.value {
                var phoneNumber = ""
                
                var originMobileNumber = contactNumberObservable.value!
                originMobileNumber.remove(at: originMobileNumber.startIndex)
                
                if Locale.current.regionCode == "KR" {
                    phoneNumber = "+82\(originMobileNumber)"
                } else if Locale.current.regionCode == "ID" {
                    phoneNumber = "+62\(originMobileNumber)"
                }
                
                let request : RegisterRequest!
                switch type {
                case .user:
                    request = RegisterRequest.init(
                        name: nameObsevable.value,
                        email: idObservable.value,
                        password: confirmedPasswordObservable.value,
                        birthdate: birthdateObservable.value,
                        phoneNumber: phoneNumber,
                        role: currentUserTypeObservable.value!.rawValue,
                        jobTitle: nil, supportAgency: nil)
                    break
                case .volunteer:
                    request = RegisterRequest.init(
                        name: nameObsevable.value,
                        email: idObservable.value,
                        password: confirmedPasswordObservable.value,
                        birthdate: birthdateObservable.value,
                        phoneNumber: phoneNumber,
                        role: currentUserTypeObservable.value!.rawValue,
                        jobTitle: nil, supportAgency: nil)
                    break
                case .supportAgency:
                    request = RegisterRequest.init(
                        name: nameObsevable.value,
                        email: idObservable.value,
                        password: confirmedPasswordObservable.value,
                        birthdate: nil,
                        phoneNumber: phoneNumber,
                        role: currentUserTypeObservable.value!.rawValue,
                        jobTitle: jobTitleObservable.value, supportAgency: supportAgencyObservable.value)
                    break
                }
                
                print("Resgister request : \(String(describing: request))")
                
                AuthService.register(registerRequest: request)
                    .subscribe(onNext: { response in
                        observer.onNext(response)
                    }).disposed(by: disposeBag)
                
            } else { observer.onError(GeneralError.errorWithMessage(message: "No Type")) }
            return Disposables.create()
        }
    }
    
    // MARK: VALIDATIONS
    func validateFirstForm()->Single<Bool?>{
        return Single.create { [unowned self] (event) -> Disposable in
            var isValid = true
            if self.idObservable.value?.isEmpty == true || self.tempPasswordObservable.value?.isEmpty == true || self.confirmedPasswordObservable.value?.isEmpty == true {
                isValid = false
                event(.failure(FormError.fieldIsEmpty))
            }
            
//            if let err = formValidator.validate(text: idObservable.value, with: [.validEmail]) {
//                event(.failure(err))
//            }
            
            if let err = formValidator.validate(text: tempPasswordObservable.value, with: [.validPassword]) {
                event(.failure(err))
            }
            
            if tempPasswordObservable.value != confirmedPasswordObservable.value {
                isValid = false
                event(.failure(FormError.passwordIsNotValid(msg: Strings.Password_Is_Not_The_Same)))
            }
            
            if isValid {
                event(.success(isValid))
            }
            
            return Disposables.create()
        }
    }
    
    func validateEmail()->Single<Bool>{
        return Single.create { [unowned self] (event) -> Disposable in
//            if let err = formValidator.validate(text: idObservable.value, with: [.notEmpty, .validEmail]) {
            if let err = formValidator.validate(text: idObservable.value, with: [.notEmpty]) {
                event(.failure(err))
            } else {
                event(.success(true))
            }
            return Disposables.create()
        }
    }
    
    func validateSecondForm()->Single<Bool?>{
        return Single.create { [unowned self] (event) -> Disposable in
            var isValid = true
            
            switch currentUserTypeObservable.value {
            case .user, .volunteer:
                // Make sure every field filled
                if let err = formValidator.validate(text: nameObsevable.value, with: [.notEmpty]),
                   let err2 = formValidator.validate(text: birthdateObservable.value, with: [.notEmpty]),
                   let err3 = formValidator.validate(text: contactNumberObservable.value, with: [.notEmpty]) {
                    for err in [err, err2, err3] {
                        isValid = false
                        event(.failure(err))
                        break
                    }
                }
                
                // Check phone number validity
                if let err = formValidator.validate(text: contactNumberObservable.value, with: [.validPhone]) {
                    isValid = false
                    event(.failure(err))
                }
                
                break
            case .supportAgency:
                // Check if all field filled
                if let err = formValidator.validate(text: nameObsevable.value, with: [.notEmpty]),
                   let err2 = formValidator.validate(text: jobTitleObservable.value, with: [.notEmpty]),
                   let err3 = formValidator.validate(text: contactNumberObservable.value, with: [.notEmpty]),
                   let err4 = formValidator.validate(text: supportAgencyObservable.value, with: [.notEmpty]){
                    for err in [err, err2, err3, err4] {
                        isValid = false
                        event(.failure(err))
                        break
                    }
                }
                
                // Check phone number validity
                if let err = formValidator.validate(text: contactNumberObservable.value, with: [.validPhone]) {
                    isValid = false
                    event(.failure(err))
                }
                break
            default:
                break
            }
            
            
            if isValid {
                event(.success(isValid))
            }
            
            return Disposables.create()
        }
    }
    
}

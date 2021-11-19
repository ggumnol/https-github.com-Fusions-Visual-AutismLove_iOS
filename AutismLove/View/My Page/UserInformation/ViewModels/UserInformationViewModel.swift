//
//  UserInformationViewModel.swift
//  AutismLove
//
//  Created by BobbyPhtr on 08/05/21.
//

import Foundation
import RxSwift
import RxCocoa

class UserInformationViewModel {
    
    var userData = Globals.userData
    private let disposeBag = DisposeBag()
    
    let phoneNumObservable = BehaviorRelay<String?>.init(value: nil)
    let birthdateObservable = BehaviorRelay<String?>.init(value: nil)
    let jobTitleObservable = BehaviorRelay<String?>.init(value: nil)
    let supportAgencyObservable = BehaviorRelay<String?>.init(value: nil)
    
    init(){
        phoneNumObservable.accept(userData?.phoneNumber)
        birthdateObservable.accept(userData?.birthdate)
        jobTitleObservable.accept(userData?.jobTitle)
        supportAgencyObservable.accept(userData?.supportAgency)
    }
    
    func saveEdittedProfile()->Observable<Response<UpdateUserResponse>>{
        return Observable.create { [unowned self] observer in
            switch self.userData?.getUserType {
            case .user:
                AuthService.updateUser(newPhoneNumber: phoneNumObservable.value!)
                    .subscribe(onNext: {
                        observer.onNext($0)
                    }, onError: {
                        observer.onError($0)
                    }).disposed(by: disposeBag)
                break
            case .volunteer:
                AuthService.updateVolunteer(newPhoneNumber: phoneNumObservable.value!, newBirthdate: birthdateObservable.value!)
                    .subscribe(onNext: {
                        observer.onNext($0)
                    }, onError: {
                        observer.onError($0)
                    }).disposed(by: disposeBag)
                break
            case .supportAgency:
                AuthService.updateSupportAgent(newPhoneNumber: phoneNumObservable.value!, jobTitle: jobTitleObservable.value!, supportAgency: supportAgencyObservable.value!)
                    .subscribe(onNext: {
                        observer.onNext($0)
                    }, onError: {
                        observer.onError($0)
                    }).disposed(by: disposeBag)
                break
            default:
                break
            }
            return Disposables.create()
        }
    }
    
    func refreshUserData(){
        userData = Globals.userData
    }
    
    func terminateAccount(password : String)->Completable{
        return Completable.create { event in
            AuthService.terminateAccount(password: password)
                .subscribe(onNext: { response in
                    if response.success == true {
                        event(.completed)
                    } else {
                        event(.error(GeneralError.errorWithMessage(message: response.message!)))
                    }
                }) { err in
                    event(.error(GeneralError.errorWithMessage(message: err.localizedDescription)))
                }
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func onLogOut()->Completable {
        return Completable.create { event in
            AuthService.logout()
                .subscribe(onNext: { response in
                    if response.success == true {
                        event(.completed)
                    } else {
                        event(.error(GeneralError.errorWithMessage(message: response.message!)))
                    }
                }) { err in
                    event(.error(GeneralError.errorWithMessage(message: err.localizedDescription)))
                }
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func updateNotification(showMessage : Bool, showRequest : Bool, showInformative : Bool)->Completable{
        print("show message \(showMessage), showRequest \(showRequest), showInformative \(showInformative)")
        return Completable.create { event in
            AuthService.updateNotifications(isShowMessageNotif: showMessage, isShowRequestNotif: showRequest, isShowInformativeNotif: showInformative)
                .subscribe(onNext: { response in
                    if response.success == true {
                        Globals.userData = response.data?.user
                        self.refreshUserData()
                        event(.completed)
                    } else {
                        event(.error(GeneralError.errorWithMessage(message: response.message!)))
                    }
                }) { err in
                    event(.error(GeneralError.errorWithMessage(message: err.localizedDescription)))
                }.disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    deinit {
        print("User Information Model deinit")
    }
}

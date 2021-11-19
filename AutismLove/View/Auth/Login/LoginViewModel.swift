//
//  LoginViewModel.swift
//  AutismLove
//
//  Created by BobbyPhtr on 01/05/21.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    private let disposeBag = DisposeBag()
    
    let idObservable = BehaviorRelay<String?>.init(value: nil)
    let passwordObservable = BehaviorRelay<String?>.init(value: nil)
    let fcmTokenObservable = BehaviorRelay<String?>.init(value: nil)
    let isIdSavedObservable = BehaviorRelay<Bool>.init(value: false)
    
    let errorObservable = PublishSubject<String?>.init()
    
    private let formValidator = FormValidator.init()
    
    init(){
        if let id =  LocalStorageManager.getStringFromUserDefaults(data: .id) {
            idObservable.accept(id)
            isIdSavedObservable.accept(true)
        }
    }
    
    func saveIdToLocal(id : String?) {
        LocalStorageManager.saveToUserDefaults(string: id, with: .id)
    }
    
    func deleteLocalId(){
        LocalStorageManager.saveToUserDefaults(string: nil, with: .id)
    }
    
    func doLogin()->Completable {
        return Completable.create {[unowned self] (event) -> Disposable in
            //            if let err = formValidator.validate(text: self.idObservable.value, with: [.notEmpty, .validEmail]) {
            if let err = formValidator.validate(text: self.idObservable.value, with: [.notEmpty]) {
                event(.error(err))
            } else if let err = formValidator.validate(text: passwordObservable.value, with: [.notEmpty, .validPassword]) {
                event(.error(err))
            } else{
                if isIdSavedObservable.value {
                    saveIdToLocal(id: idObservable.value)
                } else {
                    deleteLocalId()
                }
                AuthService.login(email: idObservable.value!, password: passwordObservable.value!, fcmToken: Globals.fcmToken ?? "")
                    .do(onError: { err in
                        event(.error(err))
                    })
                        .subscribe(onNext: { response in
                            if response.success! {
                                Globals.token = response.data?.token
                                Globals.userData = response.data?.user
                                Globals.token = response.data?.token
                                event(.completed)
                            } else {
                                event(.error(NetworkError.networkErrorWith(message: response.message)))
                            }
                        })
                        .disposed(by: disposeBag)
                        }
            return Disposables.create()
        }
    }
    
    func clearCachedData(){
        var cacheUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        cacheUrl.appendPathComponent("UserDocuments")
        
        do {
            try FileManager.default.removeItem(at: cacheUrl)
        } catch {
            print(error)
        }
        
        LocalStorageManager.saveToUserDefaults(string: nil, with: .contractCachePath)
        LocalStorageManager.saveToUserDefaults(string: nil, with: .supportPlanCachePath)
        LocalStorageManager.saveToUserDefaults(string: nil, with: .userAgreementCachePath)
    }
}

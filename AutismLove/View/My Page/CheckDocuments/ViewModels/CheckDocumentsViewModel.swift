//
//  CheckDocumentsViewModel.swift
//  AutismLove
//
//  Created by BobbyPhtr on 08/05/21.
//

import Foundation
import RxSwift
import RxCocoa

enum Files : String {
    case contracts = "contracts"
    case userAgreement = "user_agreement"
    case supportPlan = "support_plan"
}

class CheckDocumentsViewModel {
    
    private let disposeBag = DisposeBag()
    
    var volunteerInfoObservable = BehaviorRelay<InfoPopUpModel?>.init(value: InfoPopUpModel.init(name: "김 0 0", supportAgency: nil, id: "text@gmail.com", birthdate: "yyyy/mm/dd", contactInfo: "+628981389059"))
    
    var managerInfoObservable = BehaviorRelay<InfoPopUpModel?>.init(value: InfoPopUpModel.init(name: "김 0 0", supportAgency: "Bobby Agency", id: "text@gmail.com", birthdate: "yyyy/mm/dd", contactInfo: "+628981389059"))
    
    func getUserDetail()->Completable{
        return Completable.create { event in
            AuthService.getUserDetail()
                .subscribe(onNext: { response in
                    if response.success == true {
                        let volunteer = response.data?.user?.volunteer
                        let model = InfoPopUpModel.init(name: volunteer?.name, supportAgency: volunteer?.supportAgent?.name, id: volunteer?.email, birthdate: volunteer?.birthdate, contactInfo: volunteer?.phoneNumber)
                        self.volunteerInfoObservable.accept(model)
                        
                        let manager = response.data?.user?.supportAgent
                        let modelManager = InfoPopUpModel.init(name: manager?.name, supportAgency: manager?.supportAgency, id: manager?.id, birthdate: nil, contactInfo: manager?.phoneNumber)
                        self.managerInfoObservable.accept(modelManager)
                        
                        event(.completed)
                    } else {
                        event(.error(GeneralError.errorWithMessage(message: response.message!)))
                    }
                }) { err in
                    print(err)
                    event(.error(GeneralError.errorWithMessage(message: err.asAFError.debugDescription)))
                }.disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func getVolunteerInfo()->InfoPopUpModel? {
        return volunteerInfoObservable.value
    }
    
    func getManagerInfo()->InfoPopUpModel? {
        return managerInfoObservable.value
    }
    
    func getUserAgreements()->Single<DownloadResultStat>{
        return Single.create { event in
            TransactionService.downloadFile(url: (Globals.userData?.userAgreementFilePath)!, fileType: .userAgreement)
                .subscribe(onNext: { response in
                    if response.success == true {
                        print("Saved in \(response.directoryPath?.path)")
                        LocalStorageManager.saveToUserDefaults(string: response.directoryPath?.relativePath, with: .userAgreementCachePath)
                        event(.success(response))
                    }
                }, onError: { err in
                    event(.failure(err))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func getSupportPlan()->Single<DownloadResultStat>{
        return Single.create { [unowned self] event in
            TransactionService.downloadFile(url: (Globals.userData?.planFilePath)!, fileType: .supportPlan)
                .subscribe(onNext: { response in
                    if response.success == true {
                        print("Saved in \(response.directoryPath?.path)")
                        LocalStorageManager.saveToUserDefaults(string: response.directoryPath?.relativePath, with: .supportPlanCachePath)
                        event(.success(response))
                    }
                }, onError: { err in
                    event(.failure(err))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func getViewContracts()->Single<DownloadResultStat> {
        return Single.create { [unowned self] event in
            TransactionService.downloadFile(url: (Globals.userData?.contractFilePath)!, fileType: .contracts)
                .subscribe(onNext: { response in
                    if response.success == true {
                        print("Saved in \(response.directoryPath?.path)")
                        LocalStorageManager.saveToUserDefaults(string: response.directoryPath?.relativePath, with: .contractCachePath)
                        event(.success(response))
                    }
                }, onError: { err in
                    event(.failure(err))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func getPdf(fileType : Files)->URL? {
        switch fileType {
        case .contracts:
            if let url = LocalStorageManager.getStringFromUserDefaults(data: .contractCachePath) {
                print("Access in \(url)")
                return URL.init(string: url )
            } else {
                return nil
            }
        case .supportPlan:
            if let url = LocalStorageManager.getStringFromUserDefaults(data: .supportPlanCachePath) {
                print("Access in \(url)")
                return URL.init(string: url )
            } else {
                return nil
            }
        case .userAgreement:
            if let url = LocalStorageManager.getStringFromUserDefaults(data: .userAgreementCachePath) {
                print("Access in \(url)")
                return URL.init(string: url )
            } else {
                return nil
            }
        }
    }
}

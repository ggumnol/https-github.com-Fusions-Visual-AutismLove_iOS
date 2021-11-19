//
//  HomeViewModel.swift
//  AutismLove
//
//  Created by Samuel Krisna on 13/05/21.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    private let disposeBag = DisposeBag()
    
    var userData = Globals.userData
    
    let assignedUsersObservable = BehaviorRelay<[AssignedUserData]>.init(value: [])
    let notificationObservable = BehaviorRelay<[NotificationData]>.init(value: [])
    let announcementObservable = BehaviorRelay<[AnnouncementData]>.init(value: [])
    
    var assignedUser: AssignedUserData!
    
    var notificationItemTotalValue: Int?
    var notificationItemLimit: Int?
    
    var announcementItemTotalValue: Int?
    var announcementItemLimit: Int?
    
    private var page: Int = 1
    
    func refreshUserData() -> Completable {
        return Completable.create {[unowned self] event -> Disposable in
            HomeService.getUserDetail().do(onError: { err in
                event(.error(err))
            })
            .subscribe(onNext: { response in
                if response.success! {
                    Globals.userData = response.data
                    event(.completed)
                } else {
                    event(.error(NetworkError.networkErrorWith(message: response.message)))
                }
            })
            .disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getAssignedUser() -> Completable {
        return Completable.create {[unowned self] event -> Disposable in
            HomeService.getAssignedUser().do(onError: { err in
                event(.error(err))
            })
            .subscribe(onNext: { response in
                if response.success! {
                    assignedUsersObservable.append(contentsOf: (response.data?.assignedUsers)!)
                    event(.completed)
                } else {
                    event(.error(NetworkError.networkErrorWith(message: response.message)))
                }
            })
            .disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getNotification(isLoadMore : Bool = false) -> Completable {
        if isLoadMore == false {
            page = 1
        } else {
            page += 1
        }
        
        return Completable.create {[unowned self] event -> Disposable in
            HomeService.getNotification(page: page).do(onError: { err in
                event(.error(err))
            })
            .subscribe(onNext: { response in
                if response.success! {
                    notificationItemTotalValue = response.data?.total_value
                    if isLoadMore {
                        if response.message!.count > 0 {
                            notificationObservable.append(contentsOf: (response.data?.notifications)!)
                        } else {
                            page -= 1
                        }
                    } else {
                        notificationObservable.accept((response.data?.notifications)!)
                    }
                    notificationItemLimit = response.data!.limit
                    event(.completed)
                } else {
                    event(.error(NetworkError.networkErrorWith(message: response.message)))
                }
            })
            .disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getAnnouncement(isLoadMore : Bool = false) -> Completable {
        if isLoadMore == false {
            page = 1
        } else {
            page += 1
        }
        
        return Completable.create {[unowned self] event -> Disposable in
            HomeService.getAnnouncement(page: page).do(onError: { err in
                event(.error(err))
            })
            .subscribe(onNext: { response in
                if response.success! {
                    notificationItemTotalValue = response.data?.total_value
                    if isLoadMore {
                        if response.message!.count > 0 {
                            announcementObservable.append(contentsOf: (response.data?.announcements)!)
                        } else {
                            page -= 1
                        }
                    } else {
                        announcementObservable.accept((response.data?.announcements)!)
                    }
                    notificationItemLimit = response.data!.limit
                    event(.completed)
                } else {
                    event(.error(NetworkError.networkErrorWith(message: response.message)))
                }
            })
            .disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getSupportPlan()->Single<DownloadResultStat>{
        return Single.create { [unowned self] event in
            HomeService.downloadFile(url: assignedUser.planFilePath!)
                .subscribe(onNext: { response in
                    if response.success == true {
                        print("Saved in \(String(describing: response.directoryPath?.path))")
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
            HomeService.downloadFile(url: assignedUser.contractFilePath!)
                .subscribe(onNext: { response in
                    if response.success == true {
                        print("Saved in \(String(describing: response.directoryPath?.path))")
                        LocalStorageManager.saveToUserDefaults(string: response.directoryPath?.relativePath, with: .contractCachePath)
                        event(.success(response))
                    }
                }, onError: { err in
                    event(.failure(err))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func getUserAgreements()->Single<DownloadResultStat>{
        return Single.create { [self] event in
            HomeService.downloadFile(url: assignedUser.userAgreementFilePath!)
                .subscribe(onNext: { response in
                    if response.success == true {
                        print("Saved in \(String(describing: response.directoryPath?.path))")
                        LocalStorageManager.saveToUserDefaults(string: response.directoryPath?.relativePath, with: .userAgreementCachePath)
                        event(.success(response))
                    }
                }, onError: { err in
                    event(.failure(err))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}

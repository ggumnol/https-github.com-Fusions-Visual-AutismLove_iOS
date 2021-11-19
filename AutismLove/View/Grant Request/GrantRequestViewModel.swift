//
//  GrantRequestViewModel.swift
//  AutismLove
//
//  Created by Samuel Krisna on 20/05/21.
//

import Foundation
import RxSwift
import RxCocoa

class GrantRequestViewModel {
    let formValidator = FormValidator.init()
    static let shared = GrantRequestViewModel()
    private let disposeBag = DisposeBag()
    
    var statusObservable = BehaviorRelay<String?>.init(value: nil)
    var rejectedReasonObservable = BehaviorRelay<String?>.init(value: nil)
    var grantRequestIdObservable = BehaviorRelay<String?>.init(value: nil)
    var selectedUserIdObservable = BehaviorRelay<String?>.init(value: nil)
    var recipientIdObservable = BehaviorRelay<String?>.init(value: nil)
    var recipientNameObservable = BehaviorRelay<String?>.init(value: nil)
    var usagesObservable = BehaviorRelay<[Usage?]>.init(value: [])
    var requestReasonObservable = BehaviorRelay<String?>.init(value: nil)
    var bankNameObservable = BehaviorRelay<String?>.init(value: nil)
    var bankAccountNumberObservable = BehaviorRelay<String?>.init(value: nil)
    var amountObservable = BehaviorRelay<Int?>.init(value: nil)
    var grantDateObservable = BehaviorRelay<String?>.init(value: nil)
    var imageOfProofObservable = BehaviorRelay<[String?]>.init(value: [])
    var passwordObservable = BehaviorRelay<String?>.init(value: nil)
    var signaturePathObservable = BehaviorRelay<String?>.init(value: nil)
    var signatureImageObservable = BehaviorRelay<UIImage?>.init(value: nil)
    var requesterIdObservable = BehaviorRelay<String?>.init(value: nil)
    var requesterNameObservable = BehaviorRelay<String?>.init(value: nil)
    
    var isUsageFilledObservable = BehaviorRelay<Bool>.init(value: false)
    var isUploadLaterCheckedObservable = BehaviorRelay<Bool>.init(value: false)
    
    let grantRequestListObservable = BehaviorRelay<[GrantRequestData]>.init(value: [])
    let connectedUsersObservable = BehaviorRelay<[ConnectedUser]>.init(value: [])
    let assignedUsersObservable = BehaviorRelay<[AssignedUserData]>.init(value: [])
    
    var recipientList:[ConnectedUser] = []
    var proofOfImagesList:[UIImage?] = []
    var bankList:[BankData] = []
    var seenBy:[String] = []
    
    var grantRequestData: GrantRequestData!
    var assignedUserData: AssignedUserData!
    var connectedUserData: ConnectedUser!
    
    var isEditable: Bool = true
    var isRefresh: Bool = false
    
    var grantRequestItemTotalValue: Int?
    var grantRequestItemLimit: Int?
    private var page: Int = 1
    
    func createGrantRequest() -> Observable<Response<CreateGrantRequestData>> {
        return Observable.create { [unowned self]  observer -> Disposable in
            let createGrantRequest : CreateGrantRequest!
            createGrantRequest = CreateGrantRequest.init(
                usages: usagesObservable.value,
                requestReason: requestReasonObservable.value,
                signatureUrl: signaturePathObservable.value,
                grantDate: grantDateObservable.value,
                imagesOfProof: imageOfProofObservable.value
            )
            
            GrantRequestService.createGrantRequest(params: createGrantRequest)
                .subscribe(onNext: { response in
                    observer.onNext(response)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func checkPassword() -> Observable<Response<NoData>> {
        return Observable.create { [unowned self]  observer -> Disposable in
            let checkPassword : CheckPassword!
            checkPassword = CheckPassword.init(password: passwordObservable.value)
            GrantRequestService.checkPassword(params: checkPassword)
                .subscribe(onNext: { response in
                    observer.onNext(response)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func uploadProofImage(image: UIImage) -> Observable<Response<UploadImageResponse>> {
        return Observable.create { [unowned self]  observer -> Disposable in
            GrantRequestService.uploadProofImage(image: image)
                .subscribe(onNext: { response in
                    observer.onNext(response)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func uploadSignature(image: UIImage) -> Observable<Response<UploadImageResponse>> {
        return Observable.create { [unowned self]  observer -> Disposable in
            GrantRequestService.uploadSignature(image: image)
                .subscribe(onNext: { response in
                    observer.onNext(response)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getGrantRequestData(isLoadMore: Bool = false, userId: String? = nil) -> Completable {
        if isLoadMore == false {
            page = 1
        } else {
            page += 1
        }
        
        return Completable.create { [unowned self] event in
            GrantRequestService.getAllGrantRequest(page: page, userId: userId)
                .subscribe(onNext: { response in
                    if response.success! {
                        grantRequestItemTotalValue = response.data?.total_value
                        if isLoadMore {
                            if response.message!.count > 0 {
                                grantRequestListObservable.append(contentsOf: response.data!.grantRequests!)
                            } else {
                                page -= 1
                            }
                        } else {
                            grantRequestListObservable.accept(response.data!.grantRequests!)
                        }
                        grantRequestItemLimit = response.data!.limit
                        event(.completed)
                    } else {
                        event(.error(NetworkError.networkErrorWith(message: response.message)))
                    }
                }) { err in
                    event(.error(GeneralError.errorWithMessage(message: err.localizedDescription)))
                }
                .disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getAssignedUser() -> Completable {
        return Completable.create {[unowned self] event -> Disposable in
            GrantRequestService.getAssignedUser().do(onError: { err in
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
    
    func getConnectedUser() -> Completable {
        return Completable.create {[unowned self] event -> Disposable in
            GrantRequestService.getConnectedUser().do(onError: { err in
                event(.error(err))
            })
            .subscribe(onNext: { response in
                if response.success! {
                    recipientList.removeAll()
                    recipientList.append(contentsOf: (response.data?.connected_users)!)
                    connectedUsersObservable.append(contentsOf: (response.data?.connected_users)!)
                    event(.completed)
                } else {
                    event(.error(NetworkError.networkErrorWith(message: response.message)))
                }
            })
            .disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getAllBank() -> Completable {
        return Completable.create {[unowned self] event -> Disposable in
            GrantRequestService.getAllBank().do(onError: { err in
                event(.error(err))
            })
            .subscribe(onNext: { response in
                if response.success! {
                    bankList.removeAll()
                    bankList.append(contentsOf: (response.data?.banks)!)
                    
                    bankList.append(BankData(id: nil, name: Strings.AddEditUsageStrings.User_Input))
                    event(.completed)
                } else {
                    event(.error(NetworkError.networkErrorWith(message: response.message)))
                }
            })
            .disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func updateGrantRequest(action: String) -> Completable {
        return Completable.create { [unowned self] event -> Disposable in
            GrantRequestService.updateGrantRequest(id: grantRequestIdObservable.value!, action: action, rejected_reason: rejectedReasonObservable.value ).do(onError: { err in
                event(.error(err))
            })
            .subscribe(onNext: { response in
                if response.success! {
                    event(.completed)
                } else {
                    event(.error(NetworkError.networkErrorWith(message: response.message)))
                }
            })
            .disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func updateGrantRequest() -> Completable {
        return Completable.create { [unowned self] event -> Disposable in
            let updateGrantRequest : UpdateGrantRequest!
            updateGrantRequest = UpdateGrantRequest.init(usages: usagesObservable.value, request_reason: requestReasonObservable.value, grant_date: grantDateObservable.value, image_of_proof: imageOfProofObservable.value)
            GrantRequestService.updateGrantRequest(id: grantRequestIdObservable.value!, params: updateGrantRequest)
                .do(onError: { err in
                    event(.error(err))
                })
                .subscribe(onNext: { response in
                    if response.success! {
                        event(.completed)
                    } else {
                        event(.error(NetworkError.networkErrorWith(message: response.message)))
                    }
                })
                .disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func deleteGrantRequest() -> Completable {
        return Completable.create {[unowned self] event -> Disposable in
            GrantRequestService.deleteGrantRequest(id: grantRequestIdObservable.value!).do(onError: { err in
                event(.error(err))
            })
            .subscribe(onNext: { response in
                if response.success! {
                    event(.completed)
                } else {
                    event(.error(NetworkError.networkErrorWith(message: response.message)))
                }
            })
            .disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func validateUsageInput() -> Single<Bool> {
        return Single.create { [unowned self] (event) -> Disposable in
            if let err = formValidator.validate(text: recipientNameObservable.value, with: [.notEmpty]) {
                event(.failure(err))
            } else if let err = formValidator.validate(text: bankNameObservable.value, with: [.notEmpty]) {
                event(.failure(err))
            } else if let err = formValidator.validate(text: bankAccountNumberObservable.value, with: [.notEmpty]) {
                event(.failure(err))
            } else if let err = formValidator.validate(text: String(amountObservable.value!), with: [.notEmpty]) {
                event(.failure(err))
            } else {
                event(.success(true))
            }
            return Disposables.create()
        }
    }
    
    func validateAddNewFormStage() -> Single<Bool> {
        return Single.create { [unowned self] (event) in
            if let err = formValidator.validate(text: requestReasonObservable.value, with: [.notEmpty]) {
                event(.failure(err))
            } else if let err = formValidator.validate(text: usagesObservable.value[0]?.bank_name, with: [.notEmpty]) {
                event(.failure(err))
            } else if let err = formValidator.validate(text: grantDateObservable.value, with: [.notEmpty]) {
                event(.failure(err))
            } else {
                event(.success(true))
            }
            
            if isUploadLaterCheckedObservable.value {
                proofOfImagesList.removeAll()
                imageOfProofObservable.accept([])
            }
            
            return Disposables.create()
        }
    }
    
    func downloadPDF(userId: String?) -> Single<URL?> {
        return Single.create { event in
            GrantRequestService.getGrantRequestDownload(userId: userId)
                .subscribe(onNext: { [self] response in
                    if response.success == true {
                        GrantRequestService.downloadFile(url: (response.data?.path)!)
                            .subscribe(onNext: { response in
                                if response.success == true {
                                    event(.success(response.directoryPath))
                                }
                            }) { err in
                                event(.failure(GeneralError.errorWithMessage(message: err.localizedDescription)))
                            }.disposed(by: self.disposeBag)
                    } else {
                        event(.failure(GeneralError.errorWithMessage(message: response.message!)))
                    }
                }, onError: { err in
                    event(.failure(GeneralError.errorWithMessage(message: err.localizedDescription)))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func downloadGRDocument(id: String?) -> Single<URL?> {
        return Single.create { [self] event in
            GrantRequestService.getGrantRequestDocumentDownload(id: id).subscribe { response in
                if response.success == true {
                    GrantRequestService.downloadFile(url: (response.data?.path)!)
                        .subscribe(onNext: { response in
                            if response.success == true {
                                event(.success(response.directoryPath))
                            }
                        }) { err in
                            event(.failure(GeneralError.errorWithMessage(message: err.localizedDescription)))
                        }.disposed(by: self.disposeBag)
                } else {
                    event(.failure(GeneralError.errorWithMessage(message: response.message!)))
                }
            } onError: { err in
                event(.failure(GeneralError.errorWithMessage(message: err.localizedDescription)))
            }.disposed(by: disposeBag)
            return Disposables.create()
        }
    }
}

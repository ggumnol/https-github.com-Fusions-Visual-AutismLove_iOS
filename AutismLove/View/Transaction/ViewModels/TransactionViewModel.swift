//
//  TransactionViewModel.swift
//  AutismLove
//
//  Created by BobbyPhtr on 12/05/21.
//

import Foundation
import RxSwift
import RxCocoa

struct TransactionUserListModel {
    
    let assignedUser : AssignedUserData?
    let username : String?
    let subtitle : String?
    let balance : Int?
    
    var balanceString : String? {
        get {
            return balance?.toCurrency(locale: .KR)
        }
    }
}

struct TransactionUserSection : Equatable {
    static func == (lhs: TransactionUserSection, rhs: TransactionUserSection) -> Bool {
        return lhs.volunteerData?.id == rhs.volunteerData?.id
    }
    
    var isExpanded : Bool? = false
    var volunteerData : Volunteer?
    var userData : [TransactionUserListModel] = []
}

class TransactionViewModel {
    
    private let disposeBag = DisposeBag()
    
    var currentUserType : UserType? = Globals.userData?.getUserType
    
    // Assigned Users
    let assignedUserTransactionsObservableList = BehaviorRelay<[TransactionUserListModel]>.init(value: [])
    
    // List Representation
    let assignedUserDatasourceObservable = BehaviorRelay<[TransactionUserSection]>.init(value: [])
    
    let transactionListObservable = BehaviorRelay<[Transaction]>.init(value: [])
    
    private var page : Int = 1
    var transactionItemLimit : Int?
    var activeDateFilter : UITextField?
    
    let startFilterDateObservable = BehaviorRelay<Date>(value: Date())
    let endFilterDateObservable = BehaviorRelay<Date>(value: Date())
    var currentAssignedUserId : String?
    
    // Transaction List
    var currentSort : FilterSort = .newest
    var currentFilterMode : FilterMode = .desiredDate {
        didSet {
            if currentFilterMode != .desiredDate {
                if Globals.userData?.getUserType == .user {
                    getTransactions()
                        .subscribe(onCompleted: nil, onError: nil, onDisposed: nil)
                        .dispose()
                } else {
                    getTransactions(userId : currentAssignedUserId!)
                        .subscribe(onCompleted: nil, onError: nil, onDisposed: nil)
                        .dispose()
                }
                
            }
        }
    }
    
    // MARK: FILTER FOR ASSIGNED USERS
    var isGroupByUsers = BehaviorRelay<Bool>.init(value: false)
    var usersOrderType = BehaviorRelay<GroupingType>.init(value: .name)
    var userSearchKeyword = BehaviorRelay<String?>.init(value: nil)
    
    // MARK: - GET TRANSACTIONS
    func getTransactions(isLoadMore : Bool = false, userId : String? = nil)->Completable{
        
        if isLoadMore == false {
            self.page = 1
        } else {
            self.page += 1
        }
        
        switch currentFilterMode {
        case .month_1:
            var components = DateComponents()
            components.day = -30
            let minus30Date = Calendar.current.date(byAdding: components, to: Date())
            self.startFilterDateObservable.accept(minus30Date!)
            break
        case .month_6:
            var components = DateComponents()
            components.day = -180
            let minus180Date = Calendar.current.date(byAdding: components, to: Date())
            self.startFilterDateObservable.accept(minus180Date!)
            break
        case .desiredDate:
            break
        case .today:
            self.startFilterDateObservable.accept(Date().startOfDay)
            self.endFilterDateObservable.accept(Date())
            break
        case .week_1:
            var components = DateComponents()
            components.day = -7
            let minus7Date = Calendar.current.date(byAdding: components, to: Date())
            self.startFilterDateObservable.accept(minus7Date!)
            break
        }
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.string(from: startFilterDateObservable.value)
        let endDate = dateFormatter.string(from: endFilterDateObservable.value)
        
        return Completable.create { [weak self] event in
            TransactionService.getTransactions(page: self?.page ?? 0, startDate: startDate, endDate: endDate, sort: self?.currentSort ?? .newest, name: self?.userSearchKeyword.value, userId: userId)
                .subscribe(onNext: { response in
                    if response.success == true {
                        if isLoadMore {
                            if response.data!.transactions.count > 0 {
                                self?.transactionListObservable.append(contentsOf: response.data!.transactions)
                            } else {
                                self?.page -= 1
                            }
                        } else {
                            self?.transactionListObservable.accept(response.data!.transactions)
                        }
                        self?.transactionItemLimit = response.data!.limit
                        event(.completed)
                    } else {
                        event(.error(GeneralError.errorWithMessage(message: response.message!)))
                    }
                }) { err in
                    event(.error(GeneralError.errorWithMessage(message: err.localizedDescription)))
                }
                .disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        }
    }
    
    // MARK: - GET ASSIGNED USER
    func getAssignedUser()->Completable{
        return Completable.create { event in
            TransactionService.getAssignedUser(order: self.usersOrderType.value, searchKeyword: self.userSearchKeyword.value)
                .subscribe(onNext: { response in
                    if response.success == true {
                        let list = response.data?.assignedUsers!.map({ assignedUserData in
                            return TransactionUserListModel.init(assignedUser: assignedUserData, username: assignedUserData.name, subtitle: "\(assignedUserData.bankName ?? "") \(assignedUserData.bankAccountName ?? "")", balance: assignedUserData.balance)
                        })
                        self.assignedUserTransactionsObservableList.accept(list ?? [])
                        self.groupUsersToSection()
                        event(.completed)
                    } else {
                        event(.error(GeneralError.errorWithMessage(message: response.message!)))
                    }
                }) { err in
                    event(.error(err))
                }.disposed(by: self.disposeBag)
            return  Disposables.create()
        }
    }
    
    // MARK: - GROUPS VOLUNTEERS AS FILTERED
    func groupUsersToSection(){
        guard Globals.userData?.getUserType == .supportAgency else { return }
        
        let users = assignedUserTransactionsObservableList.value
        
        
        // To track exisiting filtered users and assigned volunteer
        var sectionedUser : [TransactionUserSection] = []
        var othersSection = TransactionUserSection(isExpanded: false, volunteerData: Volunteer(id: nil, name: "Others", supportAgent: nil), userData: [])
        
        for user in users {
            // 0. If volunteer in user is nil then put it to others.
            if user.assignedUser?.volunteer == nil {
                // put it inside, and skip the loop.
                othersSection.userData.append(user)
                continue
            }
            // 1. check if the section with specific volunteer already exists
            if let idx = sectionedUser.firstIndex(where: { section in
                return section.volunteerData?.id == user.assignedUser?.volunteer?.id
            }) {
                // the section with specified volunteer already exist. Add the user into them.
                sectionedUser[idx].userData.append(user)
            } else {
                // if the section is not exist
                // 2. create new section if new volunteer found and add the user.
                let section = TransactionUserSection.init(isExpanded: false, volunteerData: user.assignedUser?.volunteer, userData: [user])
                sectionedUser.append(section)
            }
        }
        
        sectionedUser.append(othersSection)
        
        //            sectionedUser.map { section in
        //                print("[\(String(describing: section.volunteerData?.name!))]")
        //                section.userData.map { print("\(String(describing: $0.username))") }
        //            }
        
        assignedUserDatasourceObservable.accept(sectionedUser)
        
    }
    
    func downloadExcel()->Single<URL?>{
        return Single.create { event in
            
            let dateFormatter = DateFormatter.init()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let startDate = dateFormatter.string(from: self.startFilterDateObservable.value)
            let endDate = dateFormatter.string(from: self.endFilterDateObservable.value)
            
            TransactionService.getTransactionDownload(startDate: startDate, endDate: endDate)
                .subscribe(onNext: { response in
                    if response.success == true {
                        print("Get download URL")
                        TransactionService.downloadFile(url: (response.data?.path)!)
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
    
}

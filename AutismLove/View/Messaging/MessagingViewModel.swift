//
//  MessagingViewModel.swift
//  AutismLove
//
//  Created by Samuel Krisna on 04/06/21.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore
import SVProgressHUD
import MessageKit
import FirebaseStorage

protocol MessagingViewModelDelegate: AnyObject {
    func reloadTableView()
}

class MessagingViewModel {
    weak var delegate: MessagingViewModelDelegate?
    
    private let disposeBag = DisposeBag()
    private let db = Firestore.firestore().collection("messaging")
    
    var recipientIdObservable = BehaviorRelay<String?>.init(value: nil)
    var textObservable = BehaviorRelay<String?>.init(value: nil)
    
    var rooms:[RoomData] = []
    
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
    
    func createMessage() -> Completable {
        return Completable.create { [unowned self] observer -> Disposable in
            let params: CreateMessage!
            params = CreateMessage.init(recipient_id: recipientIdObservable.value, message: textObservable.value)
            MessageService.createMessage(params: params).do(onError: { err in
                observer(.error(err))
            })
            .subscribe(onNext: { response in
                if response.success! {
                    observer(.completed)
                } else {
                    observer(.error(NetworkError.networkErrorWith(message: response.message)))
                }
            })
            .disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func sendImage(image: UIImage) -> Completable {
        return Completable.create { [unowned self] observer -> Disposable in
            let params = [
                "recipient_id" : recipientIdObservable.value!
            ]
            MessageService.sendImage(params: params, image: image).do(onError: { err in
                observer(.error(err))
            })
            .subscribe(onNext: { response in
                if response.success! {
                    observer(.completed)
                } else {
                    observer(.error(NetworkError.networkErrorWith(message: response.message)))
                }
            })
            .disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func sendFile(file: Data) -> Completable {
        return Completable.create { [unowned self] observer -> Disposable in
            let params = [
                "recipient_id" : recipientIdObservable.value!
            ]
            MessageService.sendFile(params: params, file: file).do(onError: { err in
                observer(.error(err))
            })
            .subscribe(onNext: { response in
                if response.success! {
                    observer(.completed)
                } else {
                    observer(.error(NetworkError.networkErrorWith(message: response.message)))
                }
            })
            .disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getAllMessage() {
        SVProgressHUD.show()
        
//        rooms.removeAll()
        
        let dialog_ids = Globals.userData?.dialog_ids
        
//      .order(by: "updated_at", descending: false)
        print("Dialog id : \(String(describing: dialog_ids))")
        
        db.whereField(FieldPath.documentID(), in: dialog_ids!).getDocuments { [self] documentSnapshot, error in
            if let snap = documentSnapshot {
                snap.documents.forEach {
                    let data = $0.data()
                    let occupantsData = data["occupants"] as! [[String:Any]]
                    let messagesData = data["messages"] as! [[String:Any]]
                    var totalUnread = 0
                    
                    var tempOtherUser: OccupantData!
                    var tempMessages:[MessageData] = []
                    
                    for occupant in occupantsData {
                        if occupant["id"] as? String != Globals.userData?.id {
                            let id = occupant["id"] as! String
                            let name = occupant["name"] as! String
                            let total_unread = occupant["total_unread"] as! Int
                            tempOtherUser = OccupantData(id: id, name: name, total_unread: total_unread)
                        } else {
                            totalUnread = occupant["total_unread"] as! Int
                        }
                    }
                    
                    if !messagesData.isEmpty {
                        for message in messagesData {
                            let created_at = message["created_at"] as? String
                            let sender_id = message["sender_id"] as? String
                            let text = message["text"] as? String
                            let type = message["type"] as? String
                            tempMessages.append(MessageData(created_at: created_at, sender_id: sender_id, text: text, type: type))
                        }
                    }
                    
                    rooms.append(RoomData(messages: tempMessages, otherUser: tempOtherUser, total_unread: totalUnread, roomId: $0.documentID))
                    
                    print("Room id: \(String(describing: $0.documentID))")
                    print("Room data: \(String(describing: tempOtherUser))")
                    
                    delegate?.reloadTableView()
                }
                SVProgressHUD.dismiss()
            } else if let error = error {
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                SVProgressHUD.dismiss(withDelay: SVProgressDelay.Long)
            }
        }
    }
    
    func getConversation(id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        SVProgressHUD.show()
        
        db.document(id).addSnapshotListener { [self] documentSnapshot, error in
            guard let document = documentSnapshot else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                SVProgressHUD.dismiss(withDelay: SVProgressDelay.SHORT)
                print("Error fetching document: \(error!)")
                return
            }
            
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            
            let occupants = data["occupants"] as! [[String:Any]]
            for occupant in occupants {
                if occupant["id"] as? String == Globals.userData?.id {
                    print(occupant)
                    
//                    db.document(id).updateData([
//                        "occupants": FieldValue.arrayRemove([[
//                            "id" : occupant["id"] as! String,
//                            "name" : occupant["name"] as! String,
//                            "total_unread" : occupant["total_unread"] as! Int
//                        ]])
//                    ])
                    
                    db.document(id).updateData([
                        "occupants": FieldValue.arrayUnion([[
                            "id" : occupant["id"] as! String,
                            "name" : occupant["name"] as! String,
                            "total_unread" : 0
                        ]])
                    ])
                }
            }
            
            let messagesData = data["messages"] as! [[String:Any]]
            
            let messages: [Message] = messagesData.compactMap { dictionary in
                let created_at = dictionary["created_at"] as? String
                let sender_id = dictionary["sender_id"] as? String
                let text = dictionary["text"] as? String
                let type = dictionary["type"] as? String
                
                var date = GlobalHelper.dateFormatter.date(from: created_at!)
                
                var kind: MessageKind?
                
                if date == nil {
                    date = Date()
                }
                
                if type == "image" {
                    guard let imageUrl = URL(string: text ?? ""), let placeHolder = UIImage(systemName: "plus") else { return nil }
                    
                    let media = Media(url: imageUrl,
                                      image: nil,
                                      placeholderImage: placeHolder,
                                      size: CGSize(width: 300, height: 300))
                    kind = .photo(media)
                } else if type == "file" {
                    let file = CustomFile(url: URL(string: text!), title: text, size: "1")
                    kind = .custom(file)
                } else {
                    kind = .text(text ?? "")
                }
                
                let sender = Sender(senderId: sender_id!,
                                    displayName: "")
                
                guard let finalKind = kind else {
                    return nil
                }
                
                return Message(sender: sender,
                               messageId: id,
                               sentDate: date!,
                               kind: finalKind)
            }
            
            completion(.success(messages))
            SVProgressHUD.dismiss()
        }
    }
    
    func downloadFile(url: URL) {
        let storage = Storage.storage()
        
        let storageRef = storage.reference()
        
        // Create a reference to the file you want to download
        let islandRef = storageRef.child("pdf/sample.pdf")
        
        // Create local filesystem URL
//        let localURL = URL(string: "pdf/sample.pdf")!
        
        let tmporaryDirectoryURL = FileManager.default.temporaryDirectory
        let localURL = tmporaryDirectoryURL.appendingPathComponent("sample.pdf")

        islandRef.write(toFile: localURL) { url, error in
            if let error = error {
               print("\(error.localizedDescription)")
            } else {
//               self.presentActivityViewController(withUrl: url)
            }
         }
    }
    
}

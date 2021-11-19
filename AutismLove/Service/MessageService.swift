//
//  MessageService.swift
//  AutismLove
//
//  Created by Samuel Krisna on 03/06/21.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import RxSwift
import RxCocoa

class MessageService {
    static let shared = MessageService()
    private let db = Firestore.firestore().collection("messaging")
    
    let messageRoomsObservable = BehaviorRelay<[RoomData]>.init(value: [])
    
    static func createMessage(params: CreateMessage) -> Observable<Response<NoData>> {
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.postWithHeader(url: URLs.Message.sendMessage, params: params.dictionary) { data, netErr in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<NoData>.self) as! Response<NoData>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    static func sendImage(params: [String: String], image: UIImage?) -> Observable<Response<UploadImageResponse>> {
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.sendImage(url: URLs.Message.sendImageMessage, image: image, params: params) { data, netErr in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<UploadImageResponse>.self) as! Response<UploadImageResponse>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    static func sendFile(params: [String: String], file: Data?) -> Observable<Response<UploadImageResponse>> {
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.sendFile(url: URLs.Message.sendFileMessage, file: file, params: params) { data, netErr in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<UploadImageResponse>.self) as! Response<UploadImageResponse>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
}

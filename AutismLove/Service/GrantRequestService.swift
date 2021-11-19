//
//  GrantRequestService.swift
//  AutismLove
//
//  Created by Samuel Krisna on 20/05/21.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class GrantRequestService {
    static func getAllBank() -> Observable<Response<BankResponse>> {
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.getWithHeader(url: URLs.GrantRequest.getBank, params: nil, onCompletion: { data, netErr in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<BankResponse>.self) as! Response<BankResponse>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            })
            return Disposables.create()
        }
    }
    
    static func createGrantRequest(params: CreateGrantRequest) -> Observable<Response<CreateGrantRequestData>> {
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.postWithHeader(url: URLs.GrantRequest.url, params: params.dictionary) { data, netErr in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<CreateGrantRequestData>.self) as! Response<CreateGrantRequestData>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    static func checkPassword(params: CheckPassword) -> Observable<Response<NoData>> {
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.postWithHeader(url: URLs.Auth.checkPassword, params: params.dictionary) { data, netErr in
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
    
    static func uploadSignature(image: UIImage?) -> Observable<Response<UploadImageResponse>> {
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.uploadImage(withName: "signature_image", url: URLs.GrantRequest.uploadSignature, image: image, onCompletion: { data, netErr in
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
            })
            return Disposables.create()
        }
    }
    
    static func uploadProofImage(image: UIImage?) -> Observable<Response<UploadImageResponse>> {
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.uploadImage(withName: "image", url: URLs.GrantRequest.uploadProofImage, image: image, onCompletion: { data, netErr in
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
            })
            return Disposables.create()
        }
    }
    
    static func getAllGrantRequest(page : Int, userId : String?) -> Observable<Response<GrantRequestResponse>> {
        let params = GetGrantRequest(page: page, user_id: userId)
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.getWithHeader(url: URLs.GrantRequest.url, params: params, onCompletion: { data, netErr in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<GrantRequestResponse>.self) as! Response<GrantRequestResponse>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            })
            return Disposables.create()
        }
    }
    
    static func getAssignedUser() -> Observable<Response<AssignedUserResponse>> {
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.getWithHeader(url: URLs.Home.getAssignedUser, params: nil, onCompletion: { data, netErr in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<AssignedUserResponse>.self) as! Response<AssignedUserResponse>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            })
            return Disposables.create()
        }
    }
    
    static func getConnectedUser() -> Observable<Response<ConnectedUserResponse>> {
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.getWithHeader(url: URLs.GrantRequest.getConnectedUser, params: nil, onCompletion: { data, netErr in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<ConnectedUserResponse>.self) as! Response<ConnectedUserResponse>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            })
            return Disposables.create()
        }
    }
    
    static func updateGrantRequest(id: String, action: String, rejected_reason: String?) -> Observable<Response<UpdateGrantRequestResponse>> {
        return Observable.create { (observer) -> Disposable in
            let url = "\(URLs.GrantRequest.url)/\(id)"
            let params = [
                "action" : action,
                "rejected_reason" : rejected_reason
            ]
            NetworkManager.shared.updateWithHeader(url: url, params: params) { data, netErr in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<UpdateGrantRequestResponse>.self) as! Response<UpdateGrantRequestResponse>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    static func updateGrantRequest(id: String, params: UpdateGrantRequest) -> Observable<Response<UpdateGrantRequestResponse>> {
        return Observable.create { (observer) -> Disposable in
            let url = "\(URLs.GrantRequest.url)/\(id)"
            
            NetworkManager.shared.updateWithHeader(url: url, params: params) { data, netErr in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<UpdateGrantRequestResponse>.self) as! Response<UpdateGrantRequestResponse>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    static func deleteGrantRequest(id: String) -> Observable<Response<DeleteGrantRequestResponse>> {
        return Observable.create { (observer) -> Disposable in
            let url = "\(URLs.GrantRequest.url)/\(id)"
            NetworkManager.shared.deleteWithHeader(url: url, params: nil) { data, netErr in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<DeleteGrantRequestResponse>.self) as! Response<DeleteGrantRequestResponse>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    static func getGrantRequestDownload(userId: String?)->Observable<Response<GrantRequestDownloadData>>{
        let params = [
            "user_id": userId
        ]
        
        return Observable.create { observer -> Disposable in
            NetworkManager.shared.getWithHeader(url: URLs.GrantRequest.downloadGrantRequest, params: params) { data, netErr in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<GrantRequestDownloadData>.self) as! Response<GrantRequestDownloadData>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    static func getGrantRequestDocumentDownload(id: String?)->Observable<Response<GrantRequestDownloadData>>{
        let params = [
            "id": id
        ]
        
        return Observable.create { observer -> Disposable in
            NetworkManager.shared.getWithHeader(url: URLs.GrantRequest.url + "/\(id!)" + "/download", params: params) { data, netErr in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<GrantRequestDownloadData>.self) as! Response<GrantRequestDownloadData>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    static func downloadFile(url : String, fileType : Files? = nil)->Observable<DownloadResultStat> {
        return Observable.create { observer->Disposable in
            var destination : DownloadRequest.Destination!
            if fileType == nil {
                destination = DownloadRequest.suggestedDownloadDestination()
            } else{
                destination = { _, _ in
                    var cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                    
                    let filename = String(url.split(separator: "/").last!)
                    
                    cacheDirectory.appendPathComponent("UserDocuments")
                    cacheDirectory.appendPathComponent(filename)
                    
                    if !FileManager.default.fileExists(atPath: cacheDirectory.relativePath) {
                        do {
                            try FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    print("Save to \(cacheDirectory.relativePath)")
                    return (cacheDirectory, .removePreviousFile)
                }
            }

            print("Download Document from : \(URLs.BASE_URL + url)")
            
            NetworkManager.shared.session.download(
                URLs.BASE_URL + "/" + url,
                method: .get,
                parameters: nil,
                encoding: JSONEncoding.default,
                headers: nil,
                to: destination).response(completionHandler: { (response) in
                    if let err = response.error {
                        observer.onError(err)
                    } else {
                        print("Download Success stored in : \(String(describing: response.fileURL?.path))")
                        let downloadReport = DownloadResultStat.init(success: true, directoryPath: response.fileURL, downloadPath: url)
                        observer.onNext(downloadReport)
                    }
                })
            
            
            return Disposables.create()
        }
    }
}

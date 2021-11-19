//
//  HomeService.swift
//  AutismLove
//
//  Created by Samuel Krisna on 14/05/21.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class HomeService {
    static func getUserDetail() -> Observable<Response<UserData>> {
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.getWithHeader(url: URLs.Auth.getUserDetail, params: nil, onCompletion: { data, netErr in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<UserData>.self) as! Response<UserData>
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
    
    static func getNotification(page : Int) -> Observable<Response<NotificationResponse>> {
        let params = GetNotificationParam(page: page)
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.getWithHeader(url: URLs.Home.getNotification, params: params, onCompletion: { data, netErr in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<NotificationResponse>.self) as! Response<NotificationResponse>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            })
            return Disposables.create()
        }
    }
    
    static func getAnnouncement(page : Int) -> Observable<Response<AnnouncementResponse>> {
        let params = GetNotificationParam(page: page)
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.getWithHeader(url: URLs.Home.getAnnouncement, params: params, onCompletion: { data, netErr in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<AnnouncementResponse>.self) as! Response<AnnouncementResponse>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            })
            return Disposables.create()
        }
    }
    
    static func downloadFile(url : String)->Observable<DownloadResultStat> {
        return Observable.create { observer->Disposable in
            var destination : DownloadRequest.Destination!
            
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

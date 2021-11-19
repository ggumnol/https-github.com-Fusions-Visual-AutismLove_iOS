//
//  TransactionService.swift
//  AutismLove
//
//  Created by BobbyPhtr on 18/05/21.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

struct DownloadResultStat {
    let success : Bool?
    let directoryPath : URL?
    let downloadPath : String?
}
    

class TransactionService {
    
    static func getAssignedUser(order : GroupingType? = nil, searchKeyword : String? = nil)->Observable<Response<AssignedUserResponse>>{
        let params = [
            "order" : order?.apiCode,
            "search" : searchKeyword
        ]
        return Observable.create { observer in
            NetworkManager.shared.getWithHeader(url: URLs.Transaction.getAssignedUsers, params: params) { data, netErr in
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
            }
            return Disposables.create()
        }
    }
    
    static func getTransactions(page : Int, startDate : String, endDate: String, sort : FilterSort, name : String? = nil, userId : String? = nil) -> Observable<Response<TransactionsData>> {
        let request = GetTransactionRequest.init(page: page, start_date: startDate, end_date: endDate, sort: sort.apiKey, receipt_name: name, user_id: userId)
        print("Request : \(request)")
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.getWithHeader(url: URLs.Transaction.getTransactions, params: request) { (data, netErr) in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<TransactionsData>.self) as! Response<TransactionsData>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    static func getTransactionDownload(startDate : String, endDate : String)->Observable<Response<TransactionDownloadData>>{
        return Observable.create { observer -> Disposable in
            NetworkManager.shared.getWithHeader(url: URLs.Transaction.downloadTransaction, params: ["start_date" : startDate, "end_date" : endDate]) { data, netErr in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<TransactionDownloadData>.self) as! Response<TransactionDownloadData>
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
                print("Save to \(String(describing: destination))")
            } else{
                destination = { _, _ in
                    var cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                    
                    let filename = String(url.split(separator: "/").last!)
                    
//                    cacheDirectory.appendPathComponent(Bundle.main.bundleIdentifier!)
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

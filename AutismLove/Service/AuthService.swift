//
//  AuthService.swift
//  AutismLove
//
//  Created by BobbyPhtr on 09/05/21.
//

import Foundation
import RxSwift
import RxCocoa

class AuthService {
    
    // MARK: REGISTER
    static func register(registerRequest : RegisterRequest)->Observable<Response<RegisterData>> {
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.post(url: URLs.Auth.register, params: registerRequest.dictionary) { (data, netErr) in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<RegisterData>.self) as! Response<RegisterData>
                        print("Register result : \(result)")
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    // MARK: LOGIN
    static func login(email : String, password : String, fcmToken : String)->Observable<Response<LoginData>> {
        let params = [
            "email" : email,
            "password" : password,
            "fcm_token" : fcmToken
        ]
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.post(url: URLs.Auth.login, params: params) { (data, netErr) in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<LoginData>.self) as! Response<LoginData>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    // MARK: GET USER DETAIL
    static func getUserDetail()->Observable<Response<GetUserDetailData>> {
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.getWithHeader(url: URLs.Auth.getUserDetail, params: nil) { (data, netErr) in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<GetUserDetailData>.self) as! Response<GetUserDetailData>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }

    
    // MARK: EMAIL CHECK
    static func checkEmail(email : String, action : String)->Observable<Response<NoData>>{
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.post(url: URLs.Auth.checkEmail, params: ["email" : email, "action" : action]) { (data, netErr) in
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
    
    // MARK: SEND OTP TO PHONE
    static func sendOTPToPhone(phoneNum : String)->Observable<Response<NoData>>{
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.post(url: URLs.Auth.sendOtp, params: ["phone_number" : phoneNum]) { (data, netErr) in
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
    
    // MARK: VERIFY OTP
    static func verifyOTPforRecoverID(otpCode : String)->Observable<Response<VerifyOtpDataRecoverID>>{
        let params = [
            "verify_token" : otpCode,
            "action" : "RECOVER_ID"
        ]
        
        print("-----------------------")
        print("          Check params : \(params)")
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.post(url: URLs.Auth.verifyOtp, params: params) { (data, netErr) in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<VerifyOtpDataRecoverID>.self) as! Response<VerifyOtpDataRecoverID>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    static func verifyOTPforReplacePassword(otpCode : String)->Observable<Response<VerifyOtpResetPasswordData>>{
        let params = [
            "verify_token" : otpCode,
            "action" : "RESET_PASSWORD"
        ]
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.post(url: URLs.Auth.verifyOtp, params: params) { (data, netErr) in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<VerifyOtpResetPasswordData>.self) as! Response<VerifyOtpResetPasswordData>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    // MARK: REPLACE PASSWORD
    static func replacePassword(reset_token : String, newPassword : String)->Observable<Response<NoData>>{
        let params = [
            "token" : reset_token,
            "new_password" : newPassword
        ]
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.update(url: URLs.Auth.resetPassword, params: params) { (data, netErr) in
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
    
    // MARK: UPDATE
    static func updateUser(newPhoneNumber : String)->Observable<Response<UpdateUserResponse>> {
        let params = [
            "phone_number" : newPhoneNumber
        ]
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.updateWithHeader(url: URLs.Auth.updateUser, params: params) { (data, netErr) in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<UpdateUserResponse>.self) as! Response<UpdateUserResponse>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    static func updateVolunteer(newPhoneNumber : String, newBirthdate : String)->Observable<Response<UpdateUserResponse>> {
        let params = [
            "phone_number" : newPhoneNumber,
            "birthdate" : newBirthdate
        ]
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.updateWithHeader(url: URLs.Auth.updateUser, params: params) { (data, netErr) in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<UpdateUserResponse>.self) as! Response<UpdateUserResponse>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    static func updateSupportAgent(newPhoneNumber : String, jobTitle : String, supportAgency : String)->Observable<Response<UpdateUserResponse>> {
        let params = [
            "phone_number" : newPhoneNumber,
            "job_title" : jobTitle,
            "support_agency" : supportAgency
        ]
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.updateWithHeader(url: URLs.Auth.updateUser, params: params) { (data, netErr) in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<UpdateUserResponse>.self) as! Response<UpdateUserResponse>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    static func updateNotifications(isShowMessageNotif : Bool, isShowRequestNotif : Bool, isShowInformativeNotif : Bool)->Observable<Response<UpdateUserResponse>>{
        var params = [String : Any]()
        params["is_show_message_notif"] = isShowMessageNotif
        params["is_show_request_notif"] = isShowRequestNotif
        params["is_show_informative_notif"] = isShowInformativeNotif
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.updateWithHeader(url: URLs.Auth.updateUser, params: params) { (data, netErr) in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<UpdateUserResponse>.self) as! Response<UpdateUserResponse>
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    // MARK: TERMINATE ACCOUNT
    static func terminateAccount(password : String)->Observable<Response<NoData>>{
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.updateWithHeader(url: URLs.Auth.terminateAccount, params: ["password" : password]) { (data, netErr) in
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
    
    // MARK: LOGOUT
    static func logout()->Observable<Response<NoData>> {
        return Observable.create { (observer) -> Disposable in
            NetworkManager.shared.postWithHeader(url: URLs.Auth.logout, params: nil) { (data, netErr) in
                if let err = netErr {
                    observer.onError(err)
                } else {
                    do {
                        let result = try NetworkManager.decode(data, dataType: Response<NoData>.self) as! Response<NoData>
                        clearCachedFiles()
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    private static func clearCachedFiles(){
        
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

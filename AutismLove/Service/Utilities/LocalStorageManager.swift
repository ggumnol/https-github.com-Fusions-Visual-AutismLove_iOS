//
//  LocalStorageManager.swift
//  AutismLove
//
//  Created by BobbyPhtr on 01/05/21.
//

import Foundation

enum SecuredDataKey : String {
    case firebaseToken = "firebaseToken"
    case sessionToken = "sessionToken"
}

enum UserDefaultsKey : String {
    case hasLaunched = "hasLaunched"
    case id = "userID"
    case userAgreementCachePath = "userAgreementCache"
    case contractCachePath = "contractCachePath"
    case supportPlanCachePath = "supportPlanCachePath"
}

class LocalStorageManager {
    
    // MARK: USER DEFAULTS
    
    static let shared : UserDefaults = UserDefaults.standard
    
    /// Turned of because the app does not auto log when the app killed.
//    static var userData : UserData? {
//        get { return getObjFromUserDefaults(with: .userData) }
//        set { saveToUserDefaults(obj: newValue, with: .userData) }
//    }
    
    static func getStringFromUserDefaults(data : UserDefaultsKey)->String?{
        return shared.string(forKey: data.rawValue)
    }
    
    static func getBoolFromUserDefaults(data : UserDefaultsKey)->Bool?{
        return shared.bool(forKey: data.rawValue)
    }
    
    static func getIntFromUserDefaults(data : UserDefaultsKey)->Int?{
        return shared.integer(forKey: data.rawValue)
    }
    
    static func getObjFromUserDefaults<T : Codable>(with key : UserDefaultsKey) -> T?  {
        if let obj = shared.string(forKey: key.rawValue) {
            do {
                let jsonDecoder = JSONDecoder()
                let data = try jsonDecoder.decode(T.self, from: obj.data(using: .utf8)!)
                return data
            }
            catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func saveToUserDefaults(string : String?, with key : UserDefaultsKey) {
        shared.setValue(string, forKey: key.rawValue)
    }
    
    static func saveToUserDefaults(bool : Bool?, with key : UserDefaultsKey) {
        shared.setValue(bool, forKey: key.rawValue)
    }
    
    static func saveToUserDefaults(int : Int?, with key : UserDefaultsKey) {
        shared.setValue(int, forKey: key.rawValue)
    }
    
    static func saveToUserDefaults<T : Codable>(obj : T?, with key : UserDefaultsKey) {
        if obj == nil {
            shared.set(nil, forKey: key.rawValue)
        } else {
            let jsonEncoder = JSONEncoder()
            do {
                let jsonData = try jsonEncoder.encode(obj!)
                let jsonString = String(data: jsonData, encoding: .utf8)
                shared.set(jsonString, forKey: key.rawValue)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

//
//  UserDefaultHelper.swift
//  AutismLove
//
//  Created by Samuel Krisna on 22/04/21.
//

import Foundation

class UserDefaultHelper {
    static let shared = UserDefaultHelper()
    
    func getLanguage() -> String? {
        let language = UserDefaults.standard.string(forKey: "language")
        
        return language
    }
}

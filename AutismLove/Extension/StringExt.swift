//
//  StringExt.swift
//  AutismLove
//
//  Created by Samuel Krisna on 28/04/21.
//

import Foundation

extension String {
    func localized() -> String {
//        let defaultLanguage = "en"
        let defaultLanguage = "korea"
        
//        if let selectedLanguage = UserDefaultHelper.shared.getLanguage() {
//            defaultLanguage = selectedLanguage
//        }
        
        return NSLocalizedString(
            self,
            tableName: defaultLanguage,
            bundle: .main,
            value: self,
            comment: self
        )
    }
}

//
//  CurrencyHelper.swift
//  AutismLove
//
//  Created by BobbyPhtr on 16/05/21.
//

import Foundation

extension Numeric {
    
    func toCurrency(locale : Locale) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        return formatter.string(for: self) ?? ""
    }
    
    func withSeparator(separator : String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator =  separator
        return formatter.string(for: self) ?? ""
    }
}

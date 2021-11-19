//
//  DateHelper.swift
//  AutismLove
//
//  Created by BobbyPhtr on 18/05/21.
//

import Foundation

class DateHelper {
    
    // 2021-03-26T03:08:54.390+0000
    func date(from string: String)->Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: string)
    }
    
    func getCurrentDate()->Date {
        return Date()
    }
    
}

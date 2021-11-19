//
//  DateExt.swift
//  AutismLove
//
//  Created by BobbyPhtr on 18/05/21.
//

import Foundation

extension Date {
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var startOfMonth: Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return  calendar.date(from: components)!
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    var dayName : String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: self)
        }
    }
    
    var monthName : String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            return dateFormatter.string(from: self)
        }
    }
    
    var day : Int {
        get {
            let calendar = Calendar.current
            return calendar.component(.day, from: self)
        }
    }
    
    var day2Digits : String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            return dateFormatter.string(from: self)
        }
    }
    
    var month : Int {
        get {
            let calendar = Calendar.current
            return calendar.component(.month, from: self)
        }
    }
    
    var month2Digits : String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM"
            return dateFormatter.string(from: self)
        }
    }
    
    var year : Int  {
        get {
            let calendar = Calendar.current
            return calendar.component(.year, from: self)
        }
    }
    
    var hour24Format : Int {
        get {
            let calendar = Calendar.current
            return calendar.component(.hour, from: self)
        }
    }
    
    var minute24Format : Int {
        get {
            let calendar = Calendar.current
            return calendar.component(.minute, from: self)
        }
    }
    
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

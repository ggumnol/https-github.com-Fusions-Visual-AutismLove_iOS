//
//  TransactionsData.swift
//  AutismLove
//
//  Created by BobbyPhtr on 18/05/21.
//

import Foundation

struct TransactionsData : Codable {
    let page : Int
    let limit : Int
    let transactions : [Transaction]
}

struct Transaction : Codable {
    let withdrawAmount: Int?
    let depositAmount: Int?
    let id: String
    let lastBalance: Int
    let user: TransactionUserData
    let createdAt, modifiedAt, transDate: String
    
    enum CodingKeys: String, CodingKey {
        case withdrawAmount = "withdraw_amount"
        case depositAmount = "deposit_amount"
        case id = "_id"
        case lastBalance = "last_balance"
        case user
        case transDate = "date"
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
    }
    
    var getStringDate : String {
        get {
            let dateHelper = DateHelper()
            let date = dateHelper.date(from: createdAt)!
            return "\(date.day)/\(date.monthName)/\(date.year)"
        }
    }
    
    var date : Date {
        get {
            let dateHelper = DateHelper()
            return dateHelper.date(from: createdAt)!
        }
    }
}

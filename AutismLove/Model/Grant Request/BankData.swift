//
//  BankData.swift
//  AutismLove
//
//  Created by Samuel Krisna on 26/05/21.
//

import Foundation

struct BankData: Codable {
    let id: String?
    let name: String?
    
    enum CodingKeys : String, CodingKey {
        case name
        case id = "_id"
    }
}

struct BankResponse: Codable {
    let banks: [BankData]?
}

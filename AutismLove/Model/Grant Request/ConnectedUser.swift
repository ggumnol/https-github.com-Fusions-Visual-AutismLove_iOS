//
//  ConnectedUser.swift
//  AutismLove
//
//  Created by Samuel Krisna on 27/05/21.
//

import Foundation

// Role User
struct ConnectedUser: Codable {
    let bank_name: String?
    let bank_account_name: String?
    let bank_account_number: String?
    let _id: String?
    let name: String?
    
    enum CodingKeys : String, CodingKey {
        case bank_name
        case bank_account_name
        case bank_account_number
        case _id
        case name
    }
}

struct ConnectedUserResponse: Codable {
    let connected_users: [ConnectedUser]?
}

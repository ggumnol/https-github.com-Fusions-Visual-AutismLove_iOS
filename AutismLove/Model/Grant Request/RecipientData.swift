//
//  RecipientData.swift
//  AutismLove
//
//  Created by Samuel Krisna on 29/05/21.
//

import Foundation

struct RecipientData: Codable {
    let id: String?
    let name: String?
    
    enum CodingKeys : String, CodingKey {
        case name
        case id = "_id"
    }
}

//
//  OccupantData.swift
//  AutismLove
//
//  Created by Samuel Krisna on 03/06/21.
//

import Foundation

struct OccupantData: Codable {
    var id: String?
    var name: String?
    var total_unread: Int?
    
    enum CodingKeys : String, CodingKey {
        case id, name, total_unread
    }
}

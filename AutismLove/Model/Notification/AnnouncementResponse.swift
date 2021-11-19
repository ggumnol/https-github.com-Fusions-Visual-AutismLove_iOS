//
//  AnnouncementResponse.swift
//  AutismLove
//
//  Created by Samuel Krisna on 03/06/21.
//

import Foundation

struct AnnouncementResponse: Codable {
    let total_value: Int?
    let page: Int?
    let limit: Int?
    let announcements: [AnnouncementData]?
    
    enum CodingKeys : String, CodingKey {
        case total_value, page, limit, announcements
    }
}

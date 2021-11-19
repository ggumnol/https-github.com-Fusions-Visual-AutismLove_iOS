//
//  AnnouncementData.swift
//  AutismLove
//
//  Created by Samuel Krisna on 03/06/21.
//

import Foundation

struct AnnouncementData: Codable {
    let _id: String?
    let title: String?
    let content: String?
    
    enum CodingKeys : String, CodingKey {
        case _id, title, content
    }
}

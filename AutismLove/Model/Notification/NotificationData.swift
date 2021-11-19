//
//  NotificationData.swift
//  AutismLove
//
//  Created by Samuel Krisna on 03/06/21.
//

import Foundation

struct NotificationData: Codable {
    let last_push_date: String?
    let _id: String?
    let title: String?
    let content: String?
    let link: String?
    let image_url: String?
    
    enum CodingKeys : String, CodingKey {
        case last_push_date, _id, title, content, link, image_url
    }
}

//
//  NotificationResponse.swift
//  AutismLove
//
//  Created by Samuel Krisna on 03/06/21.
//

import Foundation

struct NotificationResponse: Codable {
    let total_value: Int?
    let page: Int?
    let limit: Int?
    let notifications: [NotificationData]?
    
    enum CodingKeys : String, CodingKey {
        case total_value, page, limit, notifications
    }
}

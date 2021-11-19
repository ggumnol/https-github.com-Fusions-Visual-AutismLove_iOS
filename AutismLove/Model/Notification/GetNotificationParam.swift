//
//  GetNotificationParam.swift
//  AutismLove
//
//  Created by Samuel Krisna on 03/06/21.
//

import Foundation

struct GetNotificationParam: Codable {
    let page: Int?
    
    enum CodingKeys : String, CodingKey {
        case page
    }
}

//
//  Conversation.swift
//  AutismLove
//
//  Created by Samuel Krisna on 08/05/21.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
    
    enum CodingKeys:String, CodingKey {
        case id = "id"
        case name = "name"
        case otherUserEmail = "other_user_email"
        case latestMessage = "latest_message"
    }
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
    
    enum CodingKeys:String, CodingKey {
        case date = "date"
        case text = "text"
        case isRead = "is_read"
    }
}

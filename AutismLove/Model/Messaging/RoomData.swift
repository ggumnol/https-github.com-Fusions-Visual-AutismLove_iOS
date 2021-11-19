//
//  RoomData.swift
//  AutismLove
//
//  Created by Samuel Krisna on 03/06/21.
//

import Foundation

struct RoomData {
    let messages: [MessageData]?
    let otherUser: OccupantData?
    let total_unread: Int?
    let roomId: String?
}

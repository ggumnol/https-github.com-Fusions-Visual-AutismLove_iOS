//
//  CreateMessage.swift
//  AutismLove
//
//  Created by Samuel Krisna on 07/06/21.
//

import Foundation

struct CreateMessage: Encodable {
    let recipient_id: String?
    let message: String?
}

struct SendImage: Encodable {
    let recipient_id: String?
}

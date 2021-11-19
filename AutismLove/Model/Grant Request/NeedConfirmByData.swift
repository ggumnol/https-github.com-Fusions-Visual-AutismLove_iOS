//
//  NeedConfirmByData.swift
//  AutismLove
//
//  Created by Samuel Krisna on 19/06/21.
//

import Foundation

struct NeedConfirmByData: Codable {
    let _id: String?
    let name: String?
    let role: String?
    
    enum CodingKeys : String, CodingKey {
        case _id, name, role
    }
}

//
//  CheckPassword.swift
//  AutismLove
//
//  Created by Samuel Krisna on 31/05/21.
//

import Foundation

struct CheckPassword: Encodable {
    let password: String?
    
    enum CodingKeys : String, CodingKey {
        case password
    }
}

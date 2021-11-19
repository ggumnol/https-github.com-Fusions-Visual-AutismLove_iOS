//
//  RegisterData.swift
//  AutismLove
//
//  Created by BobbyPhtr on 09/05/21.
//

import Foundation

struct RegisterData : Codable {
    
    let token : String?
    let user : UserData?
    
    enum CodingKeys : String, CodingKey {
        case token = "token"
        case user = "user"
    }
}

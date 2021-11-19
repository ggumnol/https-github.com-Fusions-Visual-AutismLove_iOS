//
//  LoginData.swift
//  AutismLove
//
//  Created by BobbyPhtr on 09/05/21.
//

import Foundation

struct LoginData : Codable {
    // Set the token and userData in Globals
    let token : String?
    let user : UserData?
    
    enum CodingKeys : String, CodingKey {
        case token = "token"
        case user = "user"
    }
    
}

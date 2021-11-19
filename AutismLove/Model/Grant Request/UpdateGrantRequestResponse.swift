//
//  UpdateGrantRequestResponse.swift
//  AutismLove
//
//  Created by Samuel Krisna on 30/05/21.
//

import Foundation

struct UpdateGrantRequestResponse: Codable {
    let grantRequests: GrantRequestData?
    
    enum CodingKeys : String, CodingKey {
        case grantRequests = "grant_requests"
    }
}

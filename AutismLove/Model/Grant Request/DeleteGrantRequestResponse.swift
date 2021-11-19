//
//  DeleteGrantRequestResponse.swift
//  AutismLove
//
//  Created by Samuel Krisna on 29/05/21.
//

import Foundation

struct DeleteGrantRequestResponse: Codable {
    let grantRequests: GrantRequestData?
    
    enum CodingKeys : String, CodingKey {
        case grantRequests = "grant_requests"
    }
}

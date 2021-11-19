//
//  GrantRequestResponse.swift
//  AutismLove
//
//  Created by Samuel Krisna on 24/05/21.
//

import Foundation

struct GrantRequestResponse: Codable {
    let total_value: Int?
    let page: Int?
    let limit: Int?
    let grantRequests: [GrantRequestData]?
    
    enum CodingKeys : String, CodingKey {
        case total_value, page, limit
        case grantRequests = "grant_requests"
    }
}

//
//  UpdateGrantRequest.swift
//  AutismLove
//
//  Created by Samuel Krisna on 06/06/21.
//

import Foundation

struct UpdateGrantRequest: Encodable {
    let usages: [Usage?]
    let request_reason: String?
    let grant_date: String?
    let image_of_proof: [String?]
}

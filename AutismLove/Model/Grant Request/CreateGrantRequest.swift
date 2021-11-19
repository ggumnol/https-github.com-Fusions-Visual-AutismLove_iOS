//
//  CreateGrantRequest.swift
//  AutismLove
//
//  Created by Samuel Krisna on 19/05/21.
//

import Foundation

struct CreateGrantRequest: Encodable {
    let usages: [Usage?]
    let requestReason: String?
    let signatureUrl: String?
    let grantDate: String?
    let imagesOfProof: [String?]
    
    enum CodingKeys : String, CodingKey {
        case usages = "usages"
        case requestReason = "request_reason"
        case signatureUrl = "signature_url"
        case grantDate = "grant_date"
        case imagesOfProof = "images_of_proof"
    }
}

//
//  GrantRequestData.swift
//  AutismLove
//
//  Created by Samuel Krisna on 14/05/21.
//

import Foundation

struct GrantRequestData: Codable {
    let status: String?
    let signatureUrl: String?
    let imagesOfProof: [String]?
    let need_confirmed_by: [NeedConfirmByData?]
    let seen_by: [String]?
    let accepted_by: [AcceptedBy]?
    let _id: String?
    let usages: [Usage?]
    let requestReason: String?
    let requester: Requester?
    let grantDate: String?
    let rejected_by: [RejectedBy?]
    //    let rejectedReason: String?
    let __v: Int?
    
    enum CodingKeys : String, CodingKey {
        case status, _id, requester, need_confirmed_by, usages, seen_by, rejected_by, accepted_by, __v
        case signatureUrl = "signature_url"
        case imagesOfProof = "images_of_proof"
        case requestReason = "request_reason"
        case grantDate = "grant_date"
        //        case rejectedReason = "rejected_reason"
    }
}

struct Requester2: Codable {
    let _id: String?
    let name: String?
    let role: String?
    
    enum CodingKeys : String, CodingKey {
        case _id, name, role
    }
}

struct RejectedBy: Codable {
    let rejected_reason: String?
    let _id: String?
    let user: AcceptedBy?
    
    enum CodingKeys : String, CodingKey {
        case rejected_reason, _id, user
    }
}

struct AcceptedBy: Codable {
    let _id: String?
    let name: String?
    let role: String?
    
    enum CodingKeys : String, CodingKey {
        case _id, name, role
    }
}

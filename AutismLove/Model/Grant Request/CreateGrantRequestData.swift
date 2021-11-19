//
//  CreateGrantRequestData.swift
//  AutismLove
//
//  Created by Samuel Krisna on 25/05/21.
//

import Foundation

struct CreateGrantRequestData: Codable {
    let status: String?
    let signature_url: String?
    let amount: Int?
    let images_of_proof: [String]?
    let rejected_reason: String?
    let id: String?
    let request_reason: String?
    let bank_name: String?
    let bank_account_name: String?
    let bank_account_number: String?
    let requester: Requester?
    let recipient: String?
    let grant_date: String?
    
    enum CodingKeys : String, CodingKey {
        case status = "status"
        case signature_url = "signature_url"
        case amount = "amount"
        case images_of_proof = "images_of_proof"
        case rejected_reason = "rejected_reason"
        case id = "_id"
        case request_reason = "request_reason"
        case bank_name = "bank_name"
        case bank_account_name = "bank_account_name"
        case bank_account_number = "bank_account_number"
        case requester = "requester"
        case recipient = "recipient"
        case grant_date = "grant_date"
    }
}

struct Requester: Codable {
    let _id: String?
    let name: String?
    let birthdate: String?
    let phone_number: String?
    let role: String?
    
    enum CodingKeys : String, CodingKey {
        case _id, name, birthdate, phone_number
        case role = "role"
    }
}

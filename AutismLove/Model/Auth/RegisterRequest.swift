//
//  RegisterRequest.swift
//  AutismLove
//
//  Created by BobbyPhtr on 09/05/21.
//

import Foundation

struct RegisterRequest : Encodable {
    
    let name : String?
    let email : String?
    let password : String?
    let birthdate : String?
    let phoneNumber : String?
    /// SUPPORT_AGENT, USER, VOLUNTEER
    let role : String
    let jobTitle : String?
    let supportAgency : String?
    
    enum CodingKeys : String, CodingKey {
        case name, email, password, birthdate, role
        case phoneNumber = "phone_number"
        case jobTitle = "job_title"
        case supportAgency = "support_agency"
    }
    
}

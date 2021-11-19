//
//  UserData.swift
//  AutismLove
//
//  Created by Samuel Krisna on 26/04/21.
//

import Foundation

struct TransactionUserData : Codable {
    let balance: Int?
    let status: String?
    let contractPeriodStart: String?
    let contractPeriodEnd : String?
    let isProfileVisible: Bool?
    let bankName, bankAccountName, bankAccountNumber: String?
    let isShowMessageNotif, isShowRequestNotif, isShowInformativeNotif: Bool?
    let assignedUsers: [String]?
    let isActive: Bool?
    let id, name, email, birthdate: String?
    let phoneNumber, role: String?
    let volunteer, supportAgent: SimpleUserData?
    let createdAt, modifiedAt: String?

    enum CodingKeys: String, CodingKey {
        case balance, status
        case isProfileVisible = "is_profile_visible"
        case bankName = "bank_name"
        case bankAccountName = "bank_account_name"
        case bankAccountNumber = "bank_account_number"
        case isShowMessageNotif = "is_show_message_notif"
        case isShowRequestNotif = "is_show_request_notif"
        case isShowInformativeNotif = "is_show_informative_notif"
        case assignedUsers = "assigned_users"
        case isActive = "is_active"
        case id = "_id"
        case name, email, birthdate
        case phoneNumber = "phone_number"
        case role, volunteer
        case supportAgent = "support_agent"
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
        case contractPeriodStart = "contract_period_start"
        case contractPeriodEnd = "contract_period_end"
    }
    
    var getUserType : UserType? {
        get {
            switch role {
            case "VOLUNTEER":
                return .volunteer
            case "USER":
                return .user
            case "SUPPORT_AGENT":
                return .supportAgency
            default:
                // Probably going to be ADMIN
                return nil
            }
        }
    }
    
}

struct SimpleUserData : Codable{
    let id : String?
    let name : String?
    
    enum CondingKeys : String, CodingKey {
        case id = "_id"
        case name
    }
}

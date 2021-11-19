//
//  GetUserDetailData.swift
//  AutismLove
//
//  Created by BobbyPhtr on 02/06/21.
//

import Foundation

struct GetUserDetailData : Codable {
    let user : UserDetail?
}

struct UserDetail : Codable {
    let balance: Int?
    let status, contractPeriodStart, contractPeriodEnd: String?
    let isProfileVisible: Bool?
    let bankName, bankAccountName, bankAccountNumber: String?
    let isShowMessageNotif, isShowRequestNotif, isShowInformativeNotif: Bool?
    let assignedUsers: [SimpleIDName]?
    let isActive: Bool?
    let id, name, email, birthdate: String?
    let phoneNumber, role: String?
    let volunteer: UserDetailVolunteer?
    let supportAgent: UserDetailSupportAgent?
    let createdAt, modifiedAt: String?
    let passwordChangedAt: String?
    let assignedVolunteers: [SimpleIDName]?
    
    enum CodingKeys: String, CodingKey {
        case balance, status
        case contractPeriodStart = "contract_period_start"
        case contractPeriodEnd = "contract_period_end"
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
        case passwordChangedAt
        case assignedVolunteers = "assigned_volunteers"
    }
}

// MARK: - UserSupportAgent
struct UserDetailSupportAgent: Codable {
    let id, name, phoneNumber, supportAgency: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case phoneNumber = "phone_number"
        case supportAgency = "support_agency"
    }
}

// MARK: - Volunteer
struct UserDetailVolunteer: Codable {
    let id, name, email, birthdate: String?
    let phoneNumber: String?
    let supportAgent: SimpleIDName?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, email, birthdate
        case phoneNumber = "phone_number"
        case supportAgent = "support_agent"
    }
}

// MARK: - ID NAME
struct SimpleIDName : Codable {
    let id, name: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}

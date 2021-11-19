//
//  AssignedUserData.swift
//  AutismLove
//
//  Created by BobbyPhtr on 30/05/21.
//

import Foundation

struct AssignedUserResponse : Codable {
    
    let assignedUsers : [AssignedUserData]?
    
    enum CodingKeys : String, CodingKey {
        case assignedUsers = "assigned_users"
    }
}

struct AssignedUserData : Codable {
    let balance: Int?
    let status: String?
    let contractPeriodStart: String?
    let contractPeriodEnd : String?
    let isProfileVisible: Bool?
    let bankName, bankAccountName, bankAccountNumber: String?
    let isShowMessageNotif, isShowRequestNotif, isShowInformativeNotif: Bool?
    let assignedUsers: [String]?
    let isActive: Bool?
    let dialogIds: [String]?
    let planFilePath : String?
    let contractFilePath : String?
    let userAgreementFilePath : String?
    let fcmToken: String?
    let id, name, email, birthdate: String?
    let phoneNumber, role: String?
    let volunteer: Volunteer?
    let supportAgent: SupportAgent?
    let createdAt, modifiedAt: String?
    let passwordChangedAt: String?
    let assignedVolunteers: Volunteer?
    
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
        case dialogIds = "dialog_ids"
        case planFilePath = "plan_file_path"
        case contractFilePath = "contract_file_path"
        case userAgreementFilePath = "user_agreement_file_path"
        case fcmToken = "fcm_token"
        case id = "_id"
        case name, email, birthdate
        case phoneNumber = "phone_number"
        case role, volunteer
        case supportAgent = "support_agent"
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
        case passwordChangedAt
        case assignedVolunteers = "assigned_volunteers"
        case contractPeriodStart = "contract_period_start"
        case contractPeriodEnd = "contract_period_end"
    }
}

// MARK: - SupportAgent
struct SupportAgent: Codable {
    let id, name: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}

// MARK: - Volunteer
struct Volunteer: Codable {
    let id, name: String?
    let supportAgent: SupportAgent?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case supportAgent = "support_agent"
    }
}

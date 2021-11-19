//
//  URLs.swift
//  AutismLove
//
//  Created by BobbyPhtr on 09/05/21.
//

import Foundation

struct URLs{
    static let BASE_URL = "https://autism-love.fusionsgeek.com"
    
    struct Auth {
        static let login = BASE_URL + "/api/v1/login"
        static let register = BASE_URL + "/api/v1/register"
        static let getUserDetail = BASE_URL + "/api/v1/users"
        static let logout = BASE_URL + "/api/v1/logout"
        
        // Operations
        static let updateUser = BASE_URL + "/api/v1/users/"
        static let checkEmail = BASE_URL + "/api/v1/check-email"
        static let checkPassword = BASE_URL + "/api/v1/check-password"
        static let terminateAccount = BASE_URL + "/api/v1/users/terminate"
        
        // OTP and Passwords
        static let sendOtp = BASE_URL + "/api/v1/send-otp"
        static let verifyOtp = BASE_URL + "/api/v1/verify-otp"
        static let resetPassword = BASE_URL + "/api/v1/reset-password"
    }
    
    struct Home {
        static let getAssignedUser = BASE_URL + "/api/v1/users/assigned_users"
        static let getNotification = BASE_URL + "/api/v1/notifications"
        static let getAnnouncement = BASE_URL + "/api/v1/announcements"
    }
    
    struct GrantRequest {
        static let url = BASE_URL + "/api/v1/grant-requests"
        static let getBank = BASE_URL + "/api/v1/banks"
        static let getConnectedUser = BASE_URL + "/api/v1/users/connected-users"
        static let uploadSignature = BASE_URL + "/api/v1/upload/signature"
        static let uploadProofImage = BASE_URL + "/api/v1/upload/image-of-proof"
        static let downloadGrantRequest = BASE_URL + "/api/v1/grant-requests/download"
	}
	
    struct Transaction {
        static let getTransactions = BASE_URL + "/api/v1/transactions"
        static let downloadTransaction = BASE_URL + "/api/v1/transactions/download"
        static let getAssignedUsers = BASE_URL + "/api/v1/users/assigned_users"
    }
    
    struct Message {
        static let sendMessage = BASE_URL + "/api/v1/chats/send"
        static let sendImageMessage = BASE_URL + "/api/v1/chats/send-image"
        static let sendFileMessage = BASE_URL + "/api/v1/chats/send-file"
    }
}

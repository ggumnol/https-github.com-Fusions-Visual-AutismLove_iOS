//
//  Error.swift
//  AutismLove
//
//  Created by Samuel Krisna on 23/04/21.
//

import Foundation

struct PError {
    static let UNAUTHORIZED = "UNAUTHORIZED"
    static let NO_INTERNET_CONNECTION = "NO_INTERNET_CONNECTION"
    
    struct Message {
        static let THERE_IS_A_PROBLEM_ON_SERVER = "There is a problem with the server"
    }
}

enum GeneralError : LocalizedError {
    case errorWithMessage(message : String)
    case errorWithStatusCode(code : String, msg : String)
    
    var errorDescription: String? {
        switch self {
        case .errorWithMessage(let msg):
            return msg
        case .errorWithStatusCode(let code, let message):
            return "\(message) [\(code)]"
        }
    }
}

enum NetworkError : LocalizedError {
    case noInternetConnection
    case networkErrorWith(message : String?)
    case serverErrorWith(code : String, message : String?)
    
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return Strings.No_Internet_Connection
        case .serverErrorWith(let code, let message):
            return "\(message ?? "\(Strings.No_Message)") [\(code)]"
        case .networkErrorWith(let message):
            return "\(message ?? "\(Strings.No_Message)")"
        }
    }
}

enum FormError : LocalizedError {
    case fieldIsEmpty
    case emailIsNotValid(msg : String)
    case phoneNumberIsNotValid(msg : String)
    case passwordIsNotValid(msg : String)
    
    var errorDescription: String? {
        switch self {
        case .emailIsNotValid(let msg):
            return msg
        case .fieldIsEmpty:
            return Strings.Empty_Field
        case .phoneNumberIsNotValid(let msg):
            return msg
        case .passwordIsNotValid(let msg):
            return msg
        }
    }
}



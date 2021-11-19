//
//  VerifyOtpData.swift
//  AutismLove
//
//  Created by BobbyPhtr on 13/05/21.
//

import Foundation

struct VerifyOtpDataRecoverID : Codable {
    let user : UserData?
}

struct VerifyOtpResetPasswordData : Codable {
    let reset_token : String?
}

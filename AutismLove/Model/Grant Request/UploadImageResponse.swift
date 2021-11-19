//
//  UploadImageResponse.swift
//  AutismLove
//
//  Created by Samuel Krisna on 31/05/21.
//

import Foundation

struct UploadImageResponse: Codable {
    let path: String?
    
    enum CodingKeys : String, CodingKey {
        case path
    }
}

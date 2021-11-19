//
//  Response.swift
//  AutismLove
//
//  Created by BobbyPhtr on 09/05/21.
//

import Foundation

struct Response<T: Codable>: Codable {
    var success: Bool?
    var data: T?
    var message : String?
    
    enum CodingKeys : String, CodingKey {
        case success = "success"
        case data = "data"
        case message = "message"
    }
}

struct SuccessIntResponse<T: Codable>: Codable {
    var success: Int?
    var data: T?
    var message : String?
    
    enum CodingKeys : String, CodingKey {
        case success = "success"
        case data = "data"
        case message = "message"
    }
}

struct NoData : Codable {}

//
//  GetGrantRequest.swift
//  AutismLove
//
//  Created by Samuel Krisna on 01/06/21.
//

import Foundation

struct GetGrantRequest : Encodable{
    var page : Int?
    var user_id : String? = nil
}

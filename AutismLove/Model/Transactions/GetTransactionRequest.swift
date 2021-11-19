//
//  GetTransactionRequest.swift
//  AutismLove
//
//  Created by BobbyPhtr on 23/05/21.
//

import Foundation

struct GetTransactionRequest : Encodable{
    var page : Int?
    var start_date : String?
    var end_date : String?
    var sort : String?
    var receipt_name : String? = nil
    var user_id : String? = nil
}

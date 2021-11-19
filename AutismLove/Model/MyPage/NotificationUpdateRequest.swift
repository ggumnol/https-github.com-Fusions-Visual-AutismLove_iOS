//
//  NotificationUpdateRequest.swift
//  AutismLove
//
//  Created by BobbyPhtr on 16/05/21.
//

import Foundation

struct NotificationUpdateRequest : Encodable {

    let isShowMessageNotif : Bool?
    let isShowRequestNotif : Bool?
    let isShowInformativeNotif : Bool?
    
    enum CodingKeys : String, CodingKey {
        case isShowMessageNotif = "is_show_message_notif"
        case isShowRequestNotif = "is_show_request_notif"
        case isShowInformativeNotif = "is_show_informative_notif"
    }
}

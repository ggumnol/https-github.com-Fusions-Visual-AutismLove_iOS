//
//  MessagingRoomViewControllerExt.swift
//  AutismLove
//
//  Created by Samuel Krisna on 07/05/21.
//

import Foundation
import UIKit
import MessageKit

extension MessagesViewController {
    func createMessageId() -> String {
        let currentUid = "jersamkris-gmail-com"
        let otherUid = "other-gmail-com"
        let dateString = Date()
        
        let messageId = "\(otherUid)_\(currentUid)_\(dateString)"
        
        return messageId
    }
}

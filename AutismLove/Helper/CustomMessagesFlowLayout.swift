//
//  CustomMessagesFlowLayout.swift
//  AutismLove
//
//  Created by Samuel Krisna on 05/09/21.
//

import Foundation
import MessageKit

open class CustomMessagesFlowLayout: MessagesCollectionViewFlowLayout {
    lazy open var customMessageSizeCalculator = CustomMessageSizeCalculator(layout: self)
    
    override open func cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator {
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        if case .custom = message.kind {
            return customMessageSizeCalculator
        }
        return super.cellSizeCalculatorForItem(at: indexPath);
    }
}

open class CustomMessageSizeCalculator: MessageSizeCalculator {
    open override func messageContainerSize(for message: MessageType) -> CGSize {
        // Customize this function implementation to size your content appropriately. This example simply returns a constant size
        // Refer to the default MessageKit cell implementations, and the Example App to see how to size a custom cell dynamically
        return CGSize(width: 100, height: 40)
    }
}

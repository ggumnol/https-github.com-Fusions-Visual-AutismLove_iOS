//
//  OtherCustomFileCollectionViewCell.swift
//  AutismLove
//
//  Created by Samuel Krisna on 28/09/21.
//

import UIKit
import MessageKit

class OtherCustomFileCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var fileNameButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    open func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        containerView.roundCorners(radius: 18)
        fileNameButton.setTitleColor(.black, for: .normal)
        
        switch message.kind {
        case .custom(let data):
            if let file = data as? CustomFile {
                fileNameButton.setTitle(file.title, for: .normal)
            }
        default:
            break
        }
    }
}

//
//  MeCustomFileCollectionViewCell.swift
//  AutismLove
//
//  Created by Samuel Krisna on 28/09/21.
//

import UIKit
import MessageKit

class MeCustomFileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var fileNameLabel: UILabel!
    
    @IBOutlet var readL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    open func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        containerView.roundCorners(radius: 18)
        
        switch message.kind {
        case .custom(let data):
            if let file = data as? CustomFile {
                fileNameLabel.text = file.title
            }
        default:
            break
        }
    }
}

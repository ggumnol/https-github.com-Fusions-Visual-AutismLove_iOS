//
//  ProofImageCollectionViewCell.swift
//  AutismLove
//
//  Created by Samuel Krisna on 26/04/21.
//

import UIKit
import Kingfisher

class ProofImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.roundCorners(radius: 7)
        containerView.clipsToBounds = true
        image.clipsToBounds = true
    }
    
    func setupData(image: UIImage) {
        self.image.image = image
    }
    
    func setupData(imageUrl: URL) {
        image.kf.setImage(with: imageUrl)
    }
}

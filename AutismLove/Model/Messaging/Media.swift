//
//  Media.swift
//  AutismLove
//
//  Created by Samuel Krisna on 07/05/21.
//

import Foundation
import MessageKit

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

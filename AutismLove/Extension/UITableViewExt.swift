//
//  UITableViewExt.swift
//  AutismLove
//
//  Created by Samuel Krisna on 26/04/21.
//

import Foundation
import UIKit

class AutomaticHeightTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

//
//  UILabelExt.swift
//  AutismLove
//
//  Created by Samuel Krisna on 25/04/21.
//

import Foundation
import UIKit

extension UILabel {
    @objc var defaultFont: UIFont? {
        get { return self.font }
        set {
            /* When ViewController still in navigation stack
             and appear each time, the font label will decrease
             till will disappear, so we need to call dp just one
             time for each label .*/
            
            // check if font is nil
            guard self.font != nil else {
                return
            }
            if self.tag == 0 {  // self.tag = 0 is default value .
                self.tag = 1
                var fontSize = self.font.pointSize // we get old font size and adaptive it with multiply it with dp.
                let fontRegular = "NotoSansKR-Regular"
                let fontMedium = "NotoSansKR-Medium"
                let fontBold = "NotoSansKR-Bold"
                
                if font.pointSize == 17 {
                    fontSize = 14
                }
                
                if font.fontName.range(of: "Regular") == nil {
                    self.font = UIFont(name: fontRegular, size: fontSize)
                }
                
                if font.fontName.range(of: "Medium") == nil {
                    self.font = UIFont(name: fontMedium, size: fontSize)
                }
                
                if font.fontName.range(of: "Bold") != nil {
                    self.font = UIFont(name: fontBold, size: fontSize)

                }
            }
        }
    }
}


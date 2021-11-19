//
//  Color.swift
//  AutismLove
//
//  Created by Samuel Krisna on 23/04/21.
//

import Foundation
import UIKit

//@available(iOS, unavailable, message: "Use UIColor Extension instead")
struct Color {
    static let PRIMARY_DARK = UIColor(red: 2/255, green: 51/255, blue: 102/255, alpha: 1)
    
    static let SECONDARY_LIGHT_BLUE = UIColor.init(red: 209/255, green: 223/255, blue: 255/255, alpha: 1)
    static let SECONDARY_MEDIUM_BLUE = UIColor.init(red: 88/255, green: 135/255, blue: 247/255, alpha: 1)

    static let DARK_GRAY = UIColor.init(red: 5/255, green: 5/255, blue: 5/255, alpha: 1)
    static let BACKGROUND_LIGHT_GRAY = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
}

// Use this instead
extension UIColor {
    static let PRIMARY_DARK = UIColor(red: 2/255, green: 51/255, blue: 102/255, alpha: 1)
    
    static let SECONDARY_LIGHT_BLUE = UIColor.init(red: 209/255, green: 223/255, blue: 255/255, alpha: 1)
    static let SECONDARY_MEDIUM_BLUE = UIColor.init(red: 88/255, green: 135/255, blue: 247/255, alpha: 1)

    static let DARK_GRAY = UIColor.init(red: 5/255, green: 5/255, blue: 5/255, alpha: 1)
    static let BACKGROUND_LIGHT_GRAY = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
    
    static let LIGHT_RED = UIColor(red: 255/255, green: 103/255, blue: 103/255, alpha: 1)
}

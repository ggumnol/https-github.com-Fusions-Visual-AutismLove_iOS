//
//  GlobalHelper.swift
//  AutismLove
//
//  Created by Samuel Krisna on 10/05/21.
//

import Foundation

final class GlobalHelper {
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
}

//
//  SystemUtils.swift
//  OCR Playground
//
//  Created by Andrei Maksimovich on 07/10/2025.
//

import Foundation
import SwiftUI

final class SystemUtils {
    
    @discardableResult
    static func openApplicationSettings() -> Bool {
        guard
            let settingsURL = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settingsURL)
        else {
            return false
        }

        UIApplication.shared.open(settingsURL)
        return true
    }
    
}

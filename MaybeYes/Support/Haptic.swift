//
//  Haptic.swift
//  MaybeYes
//
//  Created by Nikita Nesporov on 05.12.2021.
//

import UIKit

struct Haptics {
    
    static func impact(_ style: Style) {
        
        switch style {
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
    }
    
    enum Style {
        case light
        case medium
        case heavy
        case error
        case success
        case warning
    }
    
    private init() {}
}

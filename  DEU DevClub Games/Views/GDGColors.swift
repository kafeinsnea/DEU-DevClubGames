//
//  GDGColors.swift
//  DEU DevClub Games
//
//  Created on 29/09/2025.
//

import SwiftUI

// Basit gradient'lar
extension ShapeStyle where Self == LinearGradient {
    static var primaryGradient: LinearGradient {
        LinearGradient(
            colors: [.blue, .green],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static var secondaryGradient: LinearGradient {
        LinearGradient(
            colors: [.red, .yellow],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    static var successGradient: LinearGradient {
        LinearGradient(
            colors: [.green, .mint],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    static var warningGradient: LinearGradient {
        LinearGradient(
            colors: [.yellow, .orange],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    static var errorGradient: LinearGradient {
        LinearGradient(
            colors: [.red, .pink],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

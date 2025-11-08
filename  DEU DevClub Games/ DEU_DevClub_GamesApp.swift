//
//  DEU_DevClub_GamesApp.swift
//  DEU DevClub Games
//
//  Created by Sena Çırak on 23.09.2025.
//

import SwiftUI

@main
struct DEU_DevClub_GamesApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .preferredColorScheme(.dark) // Liquid Glass efektleri için dark mode
        }
    }
}

//
//  Game.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import Foundation

struct Game: Identifiable, Codable {
    let id = UUID()
    let name: String
    let icon: String
    let description: String
    let isAvailable: Bool
    let gradient: [String] // Gradient renkleri için
    
    init(name: String, icon: String, description: String, isAvailable: Bool, gradient: [String] = ["#4285F4", "#34A853"]) {
        self.name = name
        self.icon = icon
        self.description = description
        self.isAvailable = isAvailable
        self.gradient = gradient
    }
}

// Sample data
extension Game {
    static let sampleGames: [Game] = [
        Game(name: "Tabu", 
             icon: "🎭", 
             description: "Takım oyunu – yasaklı kelimeleri kullanmadan anlat!", 
             isAvailable: true,
             gradient: ["#4285F4", "#34A853"]),  // DevClub Blue to Green
        
        Game(name: "Emoji Challenge", 
             icon: "😀", 
             description: "Emojilerle ipucu ver, diğerleri tahmin etsin!", 
             isAvailable: true,
             gradient: ["#EA4335", "#FBBC04"]),  // DevClub Red to Yellow
        
        Game(name: "Hikaye Oluşturma", 
             icon: "📚", 
             description: "Seçeneklere göre hikaye ilerleyecek - yaratıcılığını konuştur!", 
             isAvailable: true,
             gradient: ["#4facfe", "#00f2fe"]),  // Blue to Cyan
        
        Game(name: "Startup Challenge", 
             icon: "🚀", 
             description: "Fikir sunma yarışması - yaratıcı startup fikirleri geliştir!", 
             isAvailable: false,
             gradient: ["#ff6b6b", "#4ecdc4"])  // Red to Teal
    ]
}


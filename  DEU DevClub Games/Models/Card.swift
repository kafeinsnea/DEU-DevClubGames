//
//  Card.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import Foundation

struct Card: Identifiable, Codable {
    let id = UUID()
    let word: String
    let forbidden: [String]
    let category: String?
    
    init(word: String, forbidden: [String], category: String? = nil) {
        self.word = word
        self.forbidden = forbidden
        self.category = category
    }
}

// Sample data
extension Card {
    static let sampleCards: [Card] = [
        Card(word: "İPhone", 
             forbidden: ["Apple", "Telefon", "iOS", "Akıllı", "Cep"], 
             category: "Teknoloji"),
        
        Card(word: "Kahve", 
             forbidden: ["İçecek", "Kahverengi", "Türk", "Espresso", "Sıcak"], 
             category: "Yiyecek & İçecek"),
        
        Card(word: "Futbol", 
             forbidden: ["Top", "Kale", "Oyun", "Spor", "Messi"], 
             category: "Spor"),
        
        Card(word: "SwiftUI", 
             forbidden: ["Apple", "Framework", "iOS", "Kod", "Geliştirme"], 
             category: "Teknoloji"),
        
        Card(word: "İstanbul", 
             forbidden: ["Şehir", "Türkiye", "Boğaz", "Büyük", "Tarihi"], 
             category: "Coğrafya")
    ]
}


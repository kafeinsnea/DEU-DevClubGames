//
//  EmojiCard.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import Foundation

struct EmojiCard: Identifiable, Codable {
    let id = UUID()
    let emojis: String
    let answer: String
    let difficulty: Difficulty
    let category: String?
    
    enum Difficulty: String, CaseIterable, Codable {
        case easy = "Kolay"
        case medium = "Orta"
        case hard = "Zor"
        
        var color: String {
            switch self {
            case .easy: return "#4CAF50"
            case .medium: return "#FF9800" 
            case .hard: return "#F44336"
            }
        }
    }
    
    init(emojis: String, answer: String, difficulty: Difficulty = .medium, category: String? = nil) {
        self.emojis = emojis
        self.answer = answer
        self.difficulty = difficulty
        self.category = category
    }
}

// Sample data
extension EmojiCard {
    static let sampleCards: [EmojiCard] = [
        EmojiCard(emojis: "🍎📱", 
                 answer: "iPhone", 
                 difficulty: .easy, 
                 category: "Teknoloji"),
        
        EmojiCard(emojis: "☕️🌅", 
                 answer: "Kahvaltı", 
                 difficulty: .easy, 
                 category: "Yemek"),
        
        EmojiCard(emojis: "🎬🍿", 
                 answer: "Sinema", 
                 difficulty: .easy, 
                 category: "Eğlence"),
        
        EmojiCard(emojis: "🏠🔑💰", 
                 answer: "Ev Kredisi", 
                 difficulty: .medium, 
                 category: "Finans"),
        
        EmojiCard(emojis: "👨‍💻🐛🔍", 
                 answer: "Debug", 
                 difficulty: .hard, 
                 category: "Yazılım"),
        
        EmojiCard(emojis: "🌍🔥🌡️", 
                 answer: "Küresel Isınma", 
                 difficulty: .medium, 
                 category: "Çevre"),
        
        EmojiCard(emojis: "🎮👾🕹️", 
                 answer: "Video Oyunu", 
                 difficulty: .easy, 
                 category: "Teknoloji"),
        
        EmojiCard(emojis: "🚀🌙👨‍🚀", 
                 answer: "Uzay Yolculuğu", 
                 difficulty: .medium, 
                 category: "Bilim")
    ]
}


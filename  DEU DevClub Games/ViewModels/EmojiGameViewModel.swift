//
//  EmojiGameViewModel.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import Foundation
import SwiftUI

class EmojiGameViewModel: ObservableObject {
    @Published var cards: [EmojiCard] = []
    @Published var currentCardIndex = 0
    @Published var score = 0
    @Published var timeRemaining = 30
    @Published var isGameActive = false
    @Published var gamePhase: GamePhase = .settings
    @Published var showingAnswer = false
    @Published var userGuess = ""
    @Published var streak = 0
    @Published var maxStreak = 0
    
    // Settings
    @Published var gameDuration = 60
    @Published var selectedDifficulty: EmojiCard.Difficulty?
    @Published var selectedCategories: Set<String> = []
    
    private var timer: Timer?
    private var allCards: [EmojiCard] = []
    private var correctAnswers: [String] = []
    private var wrongAnswers: [String] = []
    
    enum GamePhase {
        case settings
        case playing
        case gameEnd
    }
    
    init() {
        loadCards()
        loadAllCategories()
    }
    
    private func loadCards() {
        guard let url = Bundle.main.url(forResource: "EmojiCards", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            // Fallback to sample data
            allCards = EmojiCard.sampleCards
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let cardData = try decoder.decode([EmojiCardData].self, from: data)
            allCards = cardData.map { data in
                let difficulty = EmojiCard.Difficulty(rawValue: data.difficulty) ?? .medium
                return EmojiCard(emojis: data.emojis, 
                               answer: data.answer, 
                               difficulty: difficulty, 
                               category: data.category)
            }
        } catch {
            print("JSON yükleme hatası: \(error)")
            allCards = EmojiCard.sampleCards
        }
    }
    
    private struct EmojiCardData: Codable {
        let emojis: String
        let answer: String
        let difficulty: String
        let category: String?
    }
    
    private func loadAllCategories() {
        let categories = Set(allCards.compactMap { $0.category })
        selectedCategories = categories
    }
    
    func startGame() {
        prepareCards()
        resetGame()
        gamePhase = .playing
        startTimer()
    }
    
    private func prepareCards() {
        var filteredCards = allCards
        
        // Filter by difficulty
        if let difficulty = selectedDifficulty {
            filteredCards = filteredCards.filter { $0.difficulty == difficulty }
        }
        
        // Filter by categories
        filteredCards = filteredCards.filter { card in
            guard let category = card.category else { return true }
            return selectedCategories.contains(category)
        }
        
        cards = Array(filteredCards.shuffled())
        currentCardIndex = 0
    }
    
    private func startTimer() {
        timeRemaining = gameDuration
        isGameActive = true
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.endGame()
            }
        }
    }
    
    func submitGuess() {
        guard let currentCard = currentCard else { return }
        
        let normalizedGuess = userGuess.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedAnswer = currentCard.answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if normalizedGuess == normalizedAnswer {
            // Correct answer
            score += getDifficultyPoints(currentCard.difficulty)
            streak += 1
            maxStreak = max(maxStreak, streak)
            correctAnswers.append(currentCard.answer)
            
            nextCard()
        } else {
            // Wrong answer
            streak = 0
            wrongAnswers.append("\(currentCard.emojis) → \(currentCard.answer)")
            showingAnswer = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.showingAnswer = false
                self.nextCard()
            }
        }
        
        userGuess = ""
    }
    
    private func getDifficultyPoints(_ difficulty: EmojiCard.Difficulty) -> Int {
        switch difficulty {
        case .easy: return 10
        case .medium: return 20
        case .hard: return 30
        }
    }
    
    func skipCard() {
        guard let currentCard = currentCard else { return }
        streak = 0
        wrongAnswers.append("\(currentCard.emojis) → \(currentCard.answer) (Atlandı)")
        nextCard()
    }
    
    private func nextCard() {
        currentCardIndex += 1
        if currentCardIndex >= cards.count {
            // Reshuffle if we run out of cards
            cards.shuffle()
            currentCardIndex = 0
        }
    }
    
    private func endGame() {
        timer?.invalidate()
        isGameActive = false
        gamePhase = .gameEnd
    }
    
    func resetGame() {
        timer?.invalidate()
        score = 0
        streak = 0
        maxStreak = 0
        currentCardIndex = 0
        userGuess = ""
        showingAnswer = false
        correctAnswers.removeAll()
        wrongAnswers.removeAll()
        isGameActive = false
    }
    
    func restartGame() {
        resetGame()
        gamePhase = .settings
    }
    
    var currentCard: EmojiCard? {
        guard currentCardIndex < cards.count else { return nil }
        return cards[currentCardIndex]
    }
    
    var allCategories: [String] {
        return Array(Set(allCards.compactMap { $0.category })).sorted()
    }
    
    var gameStats: (correct: Int, wrong: Int, accuracy: Double) {
        let correct = correctAnswers.count
        let wrong = wrongAnswers.count
        let total = correct + wrong
        let accuracy = total > 0 ? Double(correct) / Double(total) * 100 : 0
        return (correct, wrong, accuracy)
    }
    
    deinit {
        timer?.invalidate()
    }
}


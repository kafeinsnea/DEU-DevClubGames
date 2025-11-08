//
//  TabuGameViewModel.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import Foundation
import SwiftUI

class TabuGameViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var currentCardIndex = 0
    @Published var team1Score = 0
    @Published var team2Score = 0
    @Published var currentTeam = 1
    @Published var timeRemaining = 60
    @Published var isGameActive = false
    @Published var gamePhase: GamePhase = .settings
    @Published var roundsPerTeam = 3
    @Published var currentRound = 1
    @Published var maxRounds = 6
    @Published var passCount = 0
    @Published var maxPassCount = 3
    
    // Settings
    @Published var team1Name = "Takım 1"
    @Published var team2Name = "Takım 2"
    @Published var roundDuration = 60
    @Published var selectedCategories: Set<String> = []
    
    private var timer: Timer?
    private var allCards: [Card] = []
    
    enum GamePhase {
        case settings
        case playing
        case roundEnd
        case gameEnd
    }
    
    init() {
        loadCards()
        loadAllCategories()
    }
    
    private func loadCards() {
        guard let url = Bundle.main.url(forResource: "CardsGeneral", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            // Fallback to sample data
            allCards = Card.sampleCards
            return
        }
        
        do {
            allCards = try JSONDecoder().decode([Card].self, from: data)
        } catch {
            print("JSON yükleme hatası: \(error)")
            allCards = Card.sampleCards
        }
    }
    
    private func loadAllCategories() {
        let categories = Set(allCards.compactMap { $0.category })
        selectedCategories = categories
    }
    
    func startGame() {
        prepareCards()
        resetTimer()
        gamePhase = .playing
        currentTeam = 1
        currentRound = 1
        team1Score = 0
        team2Score = 0
    }
    
    private func prepareCards() {
        let filteredCards = allCards.filter { card in
            guard let category = card.category else { return true }
            return selectedCategories.contains(category)
        }
        
        cards = Array(filteredCards.shuffled().prefix(50))
        currentCardIndex = 0
    }
    
    func startRound() {
        timeRemaining = roundDuration
        isGameActive = true
        startTimer()
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.endRound()
            }
        }
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timeRemaining = roundDuration
        isGameActive = false
    }
    
    func correctAnswer() {
        if currentTeam == 1 {
            team1Score += 1
        } else {
            team2Score += 1
        }
        nextCard()
    }
    
    func skipCard() {
        if passCount < maxPassCount {
            passCount += 1
            nextCard()
        }
    }
    
    func wrongAnswer() {
        if currentTeam == 1 {
            team1Score = max(0, team1Score - 1)
        } else {
            team2Score = max(0, team2Score - 1)
        }
        nextCard()
    }
    
    private func nextCard() {
        currentCardIndex = (currentCardIndex + 1) % cards.count
    }
    
    func endRound() {
        timer?.invalidate()
        isGameActive = false
        
        if currentRound >= maxRounds {
            gamePhase = .gameEnd
        } else {
            gamePhase = .roundEnd
        }
    }
    
    func nextRound() {
        currentRound += 1
        currentTeam = currentTeam == 1 ? 2 : 1
        passCount = 0 // Pas hakkını sıfırla
        resetTimer()
        gamePhase = .playing
    }
    
    func resetGame() {
        timer?.invalidate()
        gamePhase = .settings
        currentCardIndex = 0
        team1Score = 0
        team2Score = 0
        currentTeam = 1
        currentRound = 1
        passCount = 0
        resetTimer()
    }
    
    var currentCard: Card? {
        guard currentCardIndex < cards.count else { return nil }
        return cards[currentCardIndex]
    }
    
    var currentTeamName: String {
        return currentTeam == 1 ? team1Name : team2Name
    }
    
    var winnerTeam: String? {
        guard gamePhase == .gameEnd else { return nil }
        if team1Score > team2Score {
            return team1Name
        } else if team2Score > team1Score {
            return team2Name
        } else {
            return "Berabere!"
        }
    }
    
    var allCategories: [String] {
        return Array(Set(allCards.compactMap { $0.category })).sorted()
    }
    
    deinit {
        timer?.invalidate()
    }
}


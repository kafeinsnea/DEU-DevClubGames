//
//  StoryGameViewModel.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import Foundation
import SwiftUI

class StoryGameViewModel: ObservableObject {
    @Published var currentScene: StoryScene?
    @Published var storyHistory: [String] = []
    @Published var gameState: StoryGameState = .playing
    @Published var currentStory: Story?
    @Published var characters: [StoryCharacter] = []
    @Published var selectedStory: Story?
    
    enum StoryGameState {
        case playing, ended, paused, selection
    }
    
    init() {
        loadSampleStories()
    }
    
    // MARK: - Story Management
    func loadSampleStories() {
        // Sample stories yükle
        if let firstStory = Story.sampleStories.first {
            currentStory = firstStory
            characters = firstStory.characters
        }
    }
    
    func selectStory(_ story: Story) {
        selectedStory = story
        currentStory = story
        characters = story.characters
        startStory()
    }
    
    func startStory() {
        guard let story = currentStory else { return }
        
        // İlk sahneyi bul
        if let firstScene = story.scenes.first(where: { $0.id == story.startSceneId }) {
            currentScene = firstScene
            storyHistory = [firstScene.id]
            gameState = .playing
        }
    }
    
    // MARK: - Game Actions
    func makeChoice(_ choice: StoryChoice) {
        guard let nextSceneId = choice.nextSceneId,
              let story = currentStory else { return }
        
        // Sonraki sahneyi bul
        if let nextScene = story.scenes.first(where: { $0.id == nextSceneId }) {
            currentScene = nextScene
            storyHistory.append(nextSceneId)
            
            // Oyun sonu kontrolü
            if nextScene.isEnding {
                gameState = .ended
            }
        }
    }
    
    func goBack() {
        guard storyHistory.count > 1 else { return }
        
        // Son sahneyi kaldır
        storyHistory.removeLast()
        
        // Önceki sahneye dön
        if let previousSceneId = storyHistory.last,
           let story = currentStory,
           let previousScene = story.scenes.first(where: { $0.id == previousSceneId }) {
            currentScene = previousScene
        }
    }
    
    func restartStory() {
        storyHistory = []
        startStory()
    }
    
    func pauseGame() {
        gameState = .paused
    }
    
    func resumeGame() {
        gameState = .playing
    }
    
    // MARK: - Computed Properties
    var canGoBack: Bool {
        return storyHistory.count > 1
    }
    
    var isGameEnded: Bool {
        return gameState == .ended
    }
    
    var currentSceneTitle: String {
        return currentScene?.title ?? ""
    }
    
    var currentSceneContent: String {
        return currentScene?.content ?? ""
    }
    
    var currentChoices: [StoryChoice] {
        return currentScene?.choices ?? []
    }
    
    var currentCharacterInfo: String {
        return currentScene?.characterInfo ?? ""
    }
}


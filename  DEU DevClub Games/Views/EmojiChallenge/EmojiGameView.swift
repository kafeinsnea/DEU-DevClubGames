//
//  EmojiGameView.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import SwiftUI

struct EmojiGameView: View {
    @StateObject private var viewModel = EmojiGameViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                LiquidGlassBackground()
                
                VStack(spacing: 0) {
                    // Content based on game phase
                    switch viewModel.gamePhase {
                    case .settings:
                        settingsView
                    case .playing:
                        gameView
                    case .gameEnd:
                        EmojiScoreView(viewModel: viewModel)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var settingsView: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Text("😀")
                            .font(.system(size: 60))
                        
                        Text("Emoji Challenge")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(.secondaryGradient)
                        
                        Text("Emojilerle ipucu ver, diğerleri tahmin etsin!")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top)
                    
                    // Settings Card
                    VStack(spacing: 20) {
                        // Game Duration
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "timer")
                                    .foregroundStyle(.yellow)
                                Text("Oyun Süresi")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                Spacer()
                                Text("\(viewModel.gameDuration) saniye")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundStyle(.yellow)
                            }
                            
                            Slider(
                                value: Binding(
                                    get: { Double(viewModel.gameDuration) },
                                    set: { viewModel.gameDuration = Int($0) }
                                ),
                                in: 30...180,
                                step: 30
                            )
                            .accentColor(.yellow)
                        }
                        
                        Divider()
                        
                        // Difficulty Selection
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.yellow)
                                Text("Zorluk Seviyesi")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                Spacer()
                            }
                            
                            HStack(spacing: 12) {
                                ForEach(EmojiCard.Difficulty.allCases, id: \.self) { difficulty in
                                    DifficultyButton(
                                        difficulty: difficulty,
                                        isSelected: viewModel.selectedDifficulty == difficulty
                                    ) {
                                        viewModel.selectedDifficulty = viewModel.selectedDifficulty == difficulty ? nil : difficulty
                                    }
                                }
                                
                                // All difficulties button
                                Button(action: {
                                    viewModel.selectedDifficulty = nil
                                }) {
                                    Text("Hepsi")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundStyle(viewModel.selectedDifficulty == nil ? .white : .primary)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(viewModel.selectedDifficulty == nil ? .blue : .secondary.opacity(0.2))
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        
                        Divider()
                        
                        // Categories
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "tag.fill")
                                    .foregroundStyle(.green)
                                Text("Kategoriler")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                Spacer()
                            }
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(viewModel.allCategories, id: \.self) { category in
                                    CategoryToggle(
                                        category: category,
                                        isSelected: viewModel.selectedCategories.contains(category)
                                    ) {
                                        if viewModel.selectedCategories.contains(category) {
                                            viewModel.selectedCategories.remove(category)
                                        } else {
                                            viewModel.selectedCategories.insert(category)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(24)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.quaternary, lineWidth: 1)
                    )
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            viewModel.startGame()
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "play.fill")
                                Text("Oyunu Başlat")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.secondaryGradient)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .disabled(viewModel.selectedCategories.isEmpty)
                        .opacity(viewModel.selectedCategories.isEmpty ? 0.6 : 1.0)
                        
                        //                    Button("Ana Menü") {
                        //                        dismiss()
                        //                    }
                        //                    .foregroundStyle(.primary)
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var gameView: some View {
        VStack(spacing: 0) {
            // Top Bar
            HStack {
                Button("Çıkış") {
                    viewModel.restartGame()
                    dismiss()
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.3))
                .clipShape(Capsule())
                
                Spacer()
                
                // Score
                HStack(spacing: 16) {
                    VStack(spacing: 4) {
                        Text("Skor")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white.opacity(0.8))
                        Text("\(viewModel.score)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    
                    VStack(spacing: 4) {
                        Text("Seri")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white.opacity(0.8))
                        Text("\(viewModel.streak)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(.yellow)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Spacer()
                
                // Timer
                VStack(spacing: 4) {
                    Text("\(viewModel.timeRemaining)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(viewModel.timeRemaining <= 10 ? .red : .white)
                    
                    Text("saniye")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.8))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            Spacer()
            
            // Game Content
            VStack(spacing: 30) {
                if let card = viewModel.currentCard {
                    // Emoji Display
                    VStack(spacing: 20) {
                        Text(card.emojis)
                            .font(.system(size: 120))
                            .scaleEffect(viewModel.showingAnswer ? 0.8 : 1.0)
                        
                        // Difficulty Badge
                        Text(card.difficulty.rawValue)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(hex: card.difficulty.color) ?? .blue)
                            .clipShape(Capsule())
                        
                        // Category
                        if let category = card.category {
                            Text(category)
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(.secondary.opacity(0.3))
                                .clipShape(Capsule())
                        }
                    }
                    
                    // Answer Display (when showing answer)
                    if viewModel.showingAnswer {
                        VStack(spacing: 12) {
                            Text("Doğru Cevap:")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundStyle(.white.opacity(0.8))
                            
                            Text(card.answer)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundStyle(.red)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.red.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            
            Spacer()
            
            // Input and Controls
            if !viewModel.showingAnswer {
                VStack(spacing: 16) {
                    // Text Input
                    HStack {
                        TextField("Cevabını yaz...", text: $viewModel.userGuess)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .padding()
                            .background(.regularMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .focused($isTextFieldFocused)
                            .onSubmit {
                                viewModel.submitGuess()
                            }
                        
                        Button(action: {
                            viewModel.submitGuess()
                        }) {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(.white)
                        }
                        .disabled(viewModel.userGuess.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .opacity(viewModel.userGuess.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1.0)
                    }
                    
                    // Skip Button
                    Button(action: {
                        viewModel.skipCard()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.right")
                            Text("Geç")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(.warningGradient)
                        .clipShape(Capsule())
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer(minLength: 30)
        }
        .onAppear {
            isTextFieldFocused = true
        }
    }
}

struct DifficultyButton: View {
    let difficulty: EmojiCard.Difficulty
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(difficulty.rawValue)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? Color(hex: difficulty.color) : .secondary.opacity(0.2))
                .clipShape(Capsule())
        }
    }
}

#Preview {
    EmojiGameView()
}

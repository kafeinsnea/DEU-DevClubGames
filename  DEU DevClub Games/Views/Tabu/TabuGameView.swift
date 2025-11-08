//
//  TabuGameView.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import SwiftUI

struct TabuGameView: View {
    @ObservedObject var viewModel: TabuGameViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingScore = false
    
    var body: some View {
        ZStack {
            LiquidGlassBackground()
            
            VStack(spacing: 0) {
                // Game Content
                switch viewModel.gamePhase {
                case .playing:
                    VStack(spacing: 0) {
                        // Top Bar - sadece playing durumunda
                        topBar
                        
                        Spacer()
                        
                        gameContent
                    }
                case .roundEnd:
                    TabuScoreView(viewModel: viewModel)
                case .gameEnd:
                    TabuFinalView(viewModel: viewModel)
                default:
                    EmptyView()
                }
                
                Spacer()
                
                // Bottom Controls
                if viewModel.gamePhase == .playing {
                    bottomControls
                }
            }
        }
        .onAppear {
            if viewModel.gamePhase == .settings {
                viewModel.startGame()
            }
        }
    }
    
    private var topBar: some View {
        HStack {
            Button("Çıkış") {
                dismiss()
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.3))
            .clipShape(Capsule())
            
            Spacer()
            
            // Score
            HStack(spacing: 20) {
                ScoreDisplay(
                    teamName: viewModel.team1Name,
                    score: viewModel.team1Score,
                    isActive: viewModel.currentTeam == 1
                )
                
                Text(":")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                
                ScoreDisplay(
                    teamName: viewModel.team2Name,
                    score: viewModel.team2Score,
                    isActive: viewModel.currentTeam == 2
                )
            }
            
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
    }
    
    private var gameContent: some View {
        VStack(spacing: 30) {
            // Current Team
            Text("\(viewModel.currentTeamName) Oynuyor")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.black.opacity(0.4))
                .clipShape(Capsule())
            
            // Card
            if let card = viewModel.currentCard {
                TabuCardView(card: card)
            } else {
                Text("Kart yükleniyor...")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            // Round Info
            HStack(spacing: 20) {
                RoundInfo(
                    title: "Tur",
                    value: "\(viewModel.currentRound)/\(viewModel.maxRounds)"
                )
                
                RoundInfo(
                    title: "Durum",
                    value: viewModel.isGameActive ? "Aktif" : "Bekliyor"
                )
                
                RoundInfo(
                    title: "Pas Hakkı",
                    value: "\(viewModel.passCount)/\(viewModel.maxPassCount)"
                )
            }
        }
        .padding()
    }
    
    private var bottomControls: some View {
        VStack(spacing: 16) {
            if !viewModel.isGameActive {
                // Start Round Button
                Button(action: {
                    viewModel.startRound()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "play.fill")
                        Text("Turu Başlat")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.successGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            } else {
                // Game Controls
                HStack(spacing: 12) {
                    // Skip Button
                    Button(action: {
                        viewModel.skipCard()
                    }) {
                        VStack(spacing: 6) {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 24))
                            Text("Geç")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                        }
                        .foregroundStyle(.white)
                        .frame(width: 90)
                        .padding(.vertical, 14)
                        .background(viewModel.passCount >= viewModel.maxPassCount ? AnyShapeStyle(Color.gray.opacity(0.3)) : AnyShapeStyle(.warningGradient))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(viewModel.passCount >= viewModel.maxPassCount)
                    
                    // Correct Button
                    Button(action: {
                        viewModel.correctAnswer()
                    }) {
                        VStack(spacing: 6) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 24))
                            Text("Doğru")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                        }
                        .foregroundStyle(.white)
                        .frame(width: 90)
                        .padding(.vertical, 14)
                        .background(.successGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    
                    // Wrong Button
                    Button(action: {
                        viewModel.wrongAnswer()
                    }) {
                        VStack(spacing: 6) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                            Text("Yanlış")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                        }
                        .foregroundStyle(.white)
                        .frame(width: 90)
                        .padding(.vertical, 14)
                        .background(.errorGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                
                // End Round Button
                Button(action: {
                    viewModel.endRound()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "stop.fill")
                        Text("Turu Bitir")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.errorGradient)
                    .clipShape(Capsule())
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 30)
    }
}

struct TabuCardView: View {
    let card: Card
    
    var body: some View {
        VStack(spacing: 20) {
            // Main Word
            Text(card.word.uppercased())
                .font(.system(size: 28, weight: .heavy, design: .rounded))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
                .padding(.horizontal)
            
            // Category
            if let category = card.category {
                Text(category)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(.blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.15))
                    .clipShape(Capsule())
            }
            
            Divider()
                .background(.quaternary)
            
            // Forbidden Words
            VStack(spacing: 12) {
                Text("Yasak Kelimeler")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(.red)
                
                VStack(spacing: 6) {
                    ForEach(card.forbidden, id: \.self) { word in
                        Text("• \(word)")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.quaternary, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

struct ScoreDisplay: View {
    let teamName: String
    let score: Int
    let isActive: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text(teamName)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(isActive ? .yellow : .white.opacity(0.8))
            
            Text("\(score)")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isActive ? Color.yellow.opacity(0.2) : Color.black.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isActive ? .yellow.opacity(0.5) : .clear, lineWidth: 2)
        )
    }
}

struct RoundInfo: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white.opacity(0.8))
            
            Text(value)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.black.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    TabuGameView(viewModel: TabuGameViewModel())
}

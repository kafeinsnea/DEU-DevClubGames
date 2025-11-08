//
//  TabuFinalView.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import SwiftUI

struct TabuFinalView: View {
    @ObservedObject var viewModel: TabuGameViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingCelebration = false
    @State private var confettiCounter = 0
    
    var body: some View {
        ZStack {
            // Confetti Effect
            if showingCelebration {
                ForEach(0..<50, id: \.self) { _ in
                    ConfettiPiece()
                }
            }
            
            VStack(spacing: 30) {
                // Winner Announcement
                VStack(spacing: 16) {
                    if let winner = viewModel.winnerTeam {
                        if winner == "Berabere!" {
                            Text("🤝")
                                .font(.system(size: 80))
                            
                            Text("Berabere!")
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                            
                            Text("Harika bir mücadeleydi!")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundStyle(.white.opacity(0.8))
                        } else {
                            Text("🏆")
                                .font(.system(size: 80))
                                .scaleEffect(showingCelebration ? 1.2 : 1.0)
                            
                            Text("Kazanan")
                                .font(.system(size: 24, weight: .semibold, design: .rounded))
                                .foregroundStyle(.white.opacity(0.8))
                            
                            Text(winner)
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundStyle(.yellow)
                                .scaleEffect(showingCelebration ? 1.1 : 1.0)
                        }
                    }
                }
                
                // Final Scores
                VStack(spacing: 20) {
                    Text("Final Skorları")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    HStack(spacing: 30) {
                        FinalScoreCard(
                            name: viewModel.team1Name,
                            score: viewModel.team1Score,
                            isWinner: viewModel.team1Score > viewModel.team2Score && viewModel.winnerTeam != "Berabere!"
                        )
                        
                        Text(":")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(.white)
                        
                        FinalScoreCard(
                            name: viewModel.team2Name,
                            score: viewModel.team2Score,
                            isWinner: viewModel.team2Score > viewModel.team1Score && viewModel.winnerTeam != "Berabere!"
                        )
                    }
                }
                .padding(24)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.quaternary, lineWidth: 1)
                )
                
                // Game Stats
                VStack(spacing: 16) {
                    Text("Oyun İstatistikleri")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    VStack(spacing: 12) {
                        StatRow(icon: "repeat", label: "Toplam Tur", value: "\(viewModel.maxRounds)")
                        StatRow(icon: "timer", label: "Tur Süresi", value: "\(viewModel.roundDuration)s")
                        StatRow(icon: "gamecontroller", label: "Toplam Puan", value: "\(viewModel.team1Score + viewModel.team2Score)")
                    }
                    .padding(16)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        viewModel.resetGame()
                        dismiss()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.clockwise")
                            Text("Tekrar Oyna")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "house.fill")
                            Text("Ana Menü")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
            }
            .padding(.vertical, 40)
            .padding(.horizontal, 20)
        }
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.6).delay(0.5)) {
                showingCelebration = true
            }
            
            // Start confetti animation
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                if confettiCounter < 30 {
                    confettiCounter += 1
                } else {
                    timer.invalidate()
                }
            }
        }
    }
}

struct FinalScoreCard: View {
    let name: String
    let score: Int
    let isWinner: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            if isWinner {
                HStack(spacing: 6) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 16))
                    Text("KAZANAN")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                }
                .foregroundStyle(.yellow)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.yellow.opacity(0.2))
                .clipShape(Capsule())
            }
            
            Text(name)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
            
            Text("\(score)")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(isWinner ? .yellow : .white)
        }
        .frame(minWidth: 120)
    }
}

struct StatRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.blue)
                .frame(width: 20)
            
            Text(label)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
        }
    }
}

struct ConfettiPiece: View {
    @State private var animate = false
    private let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink]
    private let startX = Double.random(in: -50...UIScreen.main.bounds.width + 50)
    private let endX = Double.random(in: -100...UIScreen.main.bounds.width + 100)
    private let duration = Double.random(in: 2...4)
    private let delay = Double.random(in: 0...2)
    
    var body: some View {
        Rectangle()
            .fill(colors.randomElement() ?? .blue)
            .frame(width: 8, height: 8)
            .position(
                x: animate ? endX : startX,
                y: animate ? UIScreen.main.bounds.height + 50 : -50
            )
            .rotationEffect(.degrees(animate ? 720 : 0))
            .onAppear {
                withAnimation(.linear(duration: duration).delay(delay)) {
                    animate = true
                }
            }
    }
}

#Preview {
    ZStack {
        LiquidGlassBackground()
        TabuFinalView(viewModel: TabuGameViewModel())
    }
}

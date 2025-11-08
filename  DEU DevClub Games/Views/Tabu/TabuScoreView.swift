//
//  TabuScoreView.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import SwiftUI

struct TabuScoreView: View {
    @ObservedObject var viewModel: TabuGameViewModel
    @State private var showingAnimation = false
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 12) {
                Text("Tur Bitti!")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                
                Text("Tur \(viewModel.currentRound) Sonuçları")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))
            }
            .scaleEffect(showingAnimation ? 1.0 : 0.8)
            .opacity(showingAnimation ? 1.0 : 0.0)
            
            // Scores
            HStack(spacing: 40) {
                TeamScoreCard(
                    name: viewModel.team1Name,
                    score: viewModel.team1Score,
                    isWinning: viewModel.team1Score > viewModel.team2Score
                )
                
                Text("VS")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))
                
                TeamScoreCard(
                    name: viewModel.team2Name,
                    score: viewModel.team2Score,
                    isWinning: viewModel.team2Score > viewModel.team1Score
                )
            }
            .scaleEffect(showingAnimation ? 1.0 : 0.9)
            .opacity(showingAnimation ? 1.0 : 0.0)
            
            // Progress
            VStack(spacing: 16) {
                Text("Oyun İlerlemesi")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                
                HStack(spacing: 8) {
                    ForEach(1...viewModel.maxRounds, id: \.self) { round in
                        Circle()
                            .fill(round <= viewModel.currentRound ? .green : .white.opacity(0.3))
                            .frame(width: 12, height: 12)
                            .scaleEffect(round == viewModel.currentRound ? 1.3 : 1.0)
                    }
                }
                
                Text("\(viewModel.currentRound)/\(viewModel.maxRounds) Tur Tamamlandı")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))
            }
            .opacity(showingAnimation ? 1.0 : 0.0)
            
            Spacer()
            
            // Next Button
            if viewModel.currentRound < viewModel.maxRounds {
                Button(action: {
                    viewModel.nextRound()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.right.circle.fill")
                        Text("Sonraki Tur")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                        Text("(\(viewModel.currentTeam == 1 ? viewModel.team2Name : viewModel.team1Name))")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.primaryGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .scaleEffect(showingAnimation ? 1.0 : 0.9)
                .opacity(showingAnimation ? 1.0 : 0.0)
            }
        }
        .padding(.vertical, 40)
        .padding(.horizontal, 20)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.3)) {
                showingAnimation = true
            }
        }
    }
}

struct TeamScoreCard: View {
    let name: String
    let score: Int
    let isWinning: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Text(name)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
            
            Text("\(score)")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(isWinning ? .yellow : .white)
            
            if isWinning {
                HStack(spacing: 4) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 14))
                    Text("Önde")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
                .foregroundStyle(.yellow)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.yellow.opacity(0.2))
                .clipShape(Capsule())
            }
        }
        .padding(20)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isWinning ? .yellow.opacity(0.5) : .clear, lineWidth: 2)
        )
    }
}

#Preview {
    ZStack {
        LiquidGlassBackground()
        TabuScoreView(viewModel: TabuGameViewModel())
    }
}

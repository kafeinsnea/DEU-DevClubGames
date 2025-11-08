//
//  EmojiScoreView.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import SwiftUI

struct EmojiScoreView: View {
    @ObservedObject var viewModel: EmojiGameViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingStats = false
    @State private var showingAnimation = false
    
    var body: some View {
        ZStack {
            LiquidGlassBackground()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 16) {
                        Text(getScoreEmoji())
                            .font(.system(size: 80))
                            .scaleEffect(showingAnimation ? 1.2 : 1.0)
                        
                        Text("Oyun Bitti!")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        
                        Text(getScoreMessage())
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .scaleEffect(showingAnimation ? 1.0 : 0.8)
                    .opacity(showingAnimation ? 1.0 : 0.0)
                    
                    // Score Card
                    VStack(spacing: 20) {
                        // Main Score
                        VStack(spacing: 12) {
                            Text("Final Skor")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundStyle(.white)
                            
                            Text("\(viewModel.score)")
                                .font(.system(size: 72, weight: .bold, design: .rounded))
                                .foregroundStyle(.secondaryGradient)
                        }
                        
                        Divider()
                            .background(.quaternary)
                        
                        // Detailed Stats
                        VStack(spacing: 16) {
                            Text("Detaylı İstatistikler")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundStyle(.white)
                            
                            let stats = viewModel.gameStats
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                StatCard(
                                    icon: "checkmark.circle.fill",
                                    title: "Doğru",
                                    value: "\(stats.correct)",
                                    color: .green
                                )
                                
                                StatCard(
                                    icon: "xmark.circle.fill",
                                    title: "Yanlış",
                                    value: "\(stats.wrong)",
                                    color: .red
                                )
                                
                                StatCard(
                                    icon: "target",
                                    title: "İsabet",
                                    value: "\(Int(stats.accuracy))%",
                                    color: .blue
                                )
                                
                                StatCard(
                                    icon: "flame.fill",
                                    title: "En Uzun Seri",
                                    value: "\(viewModel.maxStreak)",
                                    color: .yellow
                                )
                            }
                        }
                        .opacity(showingStats ? 1.0 : 0.0)
                        .offset(y: showingStats ? 0 : 20)
                    }
                    .padding(24)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.quaternary, lineWidth: 1)
                    )
                    
                    // Performance Badge
                    PerformanceBadge(accuracy: viewModel.gameStats.accuracy)
                        .opacity(showingStats ? 1.0 : 0.0)
                        .scaleEffect(showingStats ? 1.0 : 0.8)
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            viewModel.restartGame()
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "arrow.clockwise")
                                Text("Tekrar Oyna")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.secondaryGradient)
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
                    .opacity(showingStats ? 1.0 : 0.0)
                    .offset(y: showingStats ? 0 : 30)
                }
                .padding()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.3)) {
                showingAnimation = true
            }
            
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(1.0)) {
                showingStats = true
            }
        }
    }
    
    private func getScoreEmoji() -> String {
        let accuracy = viewModel.gameStats.accuracy
        switch accuracy {
        case 90...:
            return "🏆"
        case 70..<90:
            return "🎉"
        case 50..<70:
            return "👏"
        case 30..<50:
            return "😊"
        default:
            return "💪"
        }
    }
    
    private func getScoreMessage() -> String {
        let accuracy = viewModel.gameStats.accuracy
        switch accuracy {
        case 90...:
            return "Mükemmel! Emoji ustasısın! 🎯"
        case 70..<90:
            return "Harika performans! Çok iyisin! ✨"
        case 50..<70:
            return "İyi iş çıkardın! Gelişmeye devam! 🚀"
        case 30..<50:
            return "Fena değil! Pratik yapmaya devam! 📚"
        default:
            return "Başlangıç için güzel! Tekrar dene! 🌟"
        }
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            
            Text(title)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct PerformanceBadge: View {
    let accuracy: Double
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: badgeIcon)
                .font(.system(size: 20))
                .foregroundStyle(badgeColor)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(badgeTitle)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                
                Text(badgeDescription)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            Spacer()
        }
        .padding(16)
        .background(badgeColor.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(badgeColor.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var badgeIcon: String {
        switch accuracy {
        case 90...: return "crown.fill"
        case 70..<90: return "star.fill"
        case 50..<70: return "medal.fill"
        case 30..<50: return "hand.thumbsup.fill"
        default: return "heart.fill"
        }
    }
    
    private var badgeColor: Color {
        switch accuracy {
        case 90...: return .yellow
        case 70..<90: return .blue
        case 50..<70: return .green
        case 30..<50: return .red
        default: return .red
        }
    }
    
    private var badgeTitle: String {
        switch accuracy {
        case 90...: return "Emoji Ustası"
        case 70..<90: return "Emoji Uzmanı"
        case 50..<70: return "Emoji Öğrencisi"
        case 30..<50: return "Emoji Keşifçisi"
        default: return "Emoji Başlangıcı"
        }
    }
    
    private var badgeDescription: String {
        switch accuracy {
        case 90...: return "İnanılmaz bir performans sergledin!"
        case 70..<90: return "Çok başarılı bir oyun oynadın!"
        case 50..<70: return "İyi bir başlangıç yaptın!"
        case 30..<50: return "Gelişmeye devam ediyorsun!"
        default: return "Her başlangıç bir adımdır!"
        }
    }
}

#Preview {
    EmojiScoreView(viewModel: EmojiGameViewModel())
}

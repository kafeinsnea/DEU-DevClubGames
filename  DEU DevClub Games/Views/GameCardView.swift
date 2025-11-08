//
//  GameCardView.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import SwiftUI

struct GameCardView: View {
    let game: Game
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Card Background with Liquid Glass Effect
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(
                                LinearGradient(
                                    colors: gradientColors,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                VStack(spacing: 16) {
                    // Game Icon
                    Text(game.icon)
                        .font(.system(size: 50))
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                    
                    // Game Info
                    VStack(spacing: 8) {
                        Text(game.name)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                        
                        Text(game.description)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                    }
                    
                    // Status Badge
                    HStack {
                        if game.isAvailable {
                            Label("Oyna", systemImage: "play.fill")
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    LinearGradient(
                                        colors: gradientColors,
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .clipShape(Capsule())
                        } else {
                            Label("Yakında", systemImage: "clock.fill")
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundStyle(.orange)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.orange.opacity(0.15))
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(20)
                .opacity(game.isAvailable ? 1.0 : 0.7)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .frame(height: 200)
    }
    
    private var gradientColors: [Color] {
        game.gradient.compactMap { hex in
            Color(hex: hex)
        }
    }
}

// Color extension for hex colors
extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 15) {
            GameCardView(game: Game.sampleGames[0]) { }
            GameCardView(game: Game.sampleGames[1]) { }
        }
        HStack(spacing: 15) {
            GameCardView(game: Game.sampleGames[2]) { }
            GameCardView(game: Game.sampleGames[3]) { }
        }
    }
    .padding()
    .background(LiquidGlassBackground())
}

//
//  LiquidGlassBackground.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import SwiftUI

struct LiquidGlassBackground: View {
    @State private var moveGradient = false
    
    var body: some View {
        ZStack {
            // Base gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.2),
                    Color(red: 0.2, green: 0.1, blue: 0.3),
                    Color(red: 0.1, green: 0.2, blue: 0.4)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animated gradient blobs
            ZStack {
                // First blob
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.blue.opacity(0.6),
                                Color.red.opacity(0.4),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 200
                        )
                    )
                    .frame(width: 400, height: 400)
                    .offset(
                        x: moveGradient ? -100 : 100,
                        y: moveGradient ? -150 : 150
                    )
                    .blur(radius: 40)
                
                // Second blob
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.pink.opacity(0.5),
                                Color.orange.opacity(0.3),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 150
                        )
                    )
                    .frame(width: 300, height: 300)
                    .offset(
                        x: moveGradient ? 120 : -120,
                        y: moveGradient ? 200 : -200
                    )
                    .blur(radius: 30)
                
                // Third blob
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.cyan.opacity(0.4),
                                Color.green.opacity(0.2),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 180
                        )
                    )
                    .frame(width: 350, height: 350)
                    .offset(
                        x: moveGradient ? 80 : -80,
                        y: moveGradient ? -100 : 100
                    )
                    .blur(radius: 50)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                    moveGradient.toggle()
                }
            }
            
            // Glass overlay
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
                .opacity(0.3)
        }
    }
}

#Preview {
    LiquidGlassBackground()
}


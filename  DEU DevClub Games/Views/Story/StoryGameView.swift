//
//  StoryGameView.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import SwiftUI

struct StoryGameView: View {
    @StateObject private var viewModel = StoryGameViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showCharacterInfo = false
    
    var body: some View {
        ZStack {
            // Karanlık arka plan (HTML'deki gibi)
            Color.black
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Top Bar
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                Text("Çıkış")
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Capsule())
                        }
                        
                        Spacer()
                        
                        // Geri Dön Butonu
                        if viewModel.canGoBack {
                            Button(action: {
                                withAnimation {
                                    viewModel.goBack()
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "arrow.uturn.backward")
                                    Text("Geri")
                                }
                                .foregroundStyle(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Story Content
                    if let scene = viewModel.currentScene {
                        VStack(spacing: 20) {
                            // Scene Title
                            if !scene.title.isEmpty {
                                Text(scene.title)
                                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                                    .foregroundStyle(Color(red: 1.0, green: 0.7, blue: 0.7))
                                    .textCase(nil)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            
                            // Story Passage (HTML'deki tw-passage gibi)
                            VStack(alignment: .leading, spacing: 16) {
                                Text(scene.content)
                                    .font(.system(size: 18, design: .rounded))
                                    .foregroundStyle(.white)
                                    .lineSpacing(8)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(30)
                            .frame(maxWidth: 700)
                            .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: .black.opacity(0.5), radius: 15, x: 0, y: 5)
                            .padding(.horizontal)
                            
                            // Character Info Button
                            if let characterInfo = scene.characterInfo, !characterInfo.isEmpty {
                                Button(action: {
                                    showCharacterInfo.toggle()
                                }) {
                                    HStack {
                                        Image(systemName: "person.2.fill")
                                        Text("Karakterler")
                                            .font(.system(size: 16, weight: .medium))
                                    }
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.white.opacity(0.1))
                                    .clipShape(Capsule())
                                }
                                
                                if showCharacterInfo {
                                    Text(characterInfo)
                                        .font(.system(size: 14, design: .rounded))
                                        .foregroundStyle(.white.opacity(0.8))
                                        .padding(20)
                                        .frame(maxWidth: 700)
                                        .background(Color.white.opacity(0.05))
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .padding(.horizontal)
                                        .transition(.opacity.combined(with: .scale))
                                }
                            }
                            
                            // Choices (HTML'deki tw-link gibi)
                            if !scene.choices.isEmpty && !scene.isEnding {
                                VStack(spacing: 16) {
                                    Text("Seçiminiz:")
                                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                                        .foregroundStyle(.white.opacity(0.9))
                                    
                                    ForEach(scene.choices) { choice in
                                        Button(action: {
                                            withAnimation {
                                                viewModel.makeChoice(choice)
                                            }
                                        }) {
                                            HStack {
                                                Text(choice.text)
                                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                                    .foregroundStyle(.white)
                                                    .multilineTextAlignment(.leading)
                                                
                                                Spacer()
                                                
                                                Image(systemName: "arrow.right")
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .foregroundStyle(.white.opacity(0.7))
                                            }
                                            .padding(18)
                                            .frame(maxWidth: 700)
                                            .background(Color(red: 0.17, green: 0.17, blue: 0.17))
                                            .clipShape(RoundedRectangle(cornerRadius: 14))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 14)
                                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                            )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .simultaneousGesture(
                                            TapGesture().onEnded { _ in
                                                // Haptic feedback
                                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                                generator.impactOccurred()
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // Ending Screen
                            if scene.isEnding {
                                VStack(spacing: 20) {
                                    Text("Hikaye Bitti")
                                        .font(.system(size: 32, weight: .bold, design: .rounded))
                                        .foregroundStyle(Color(red: 1.0, green: 0.7, blue: 0.7))
                                    
                                    Button(action: {
                                        viewModel.restartStory()
                                    }) {
                                        HStack(spacing: 12) {
                                            Image(systemName: "arrow.clockwise")
                                            Text("Yeniden Oyna")
                                                .font(.system(size: 18, weight: .semibold))
                                        }
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 14)
                                        .background(Color.white.opacity(0.15))
                                        .clipShape(Capsule())
                                    }
                                }
                                .padding(.vertical, 40)
                            }
                        }
                        .padding(.vertical, 20)
                    }
                }
            }
        }
        .onAppear {
            if viewModel.currentScene == nil {
                viewModel.startStory()
            }
        }
    }
}

#Preview {
    StoryGameView()
}


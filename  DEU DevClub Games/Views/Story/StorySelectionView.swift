//
//  StorySelectionView.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import SwiftUI

struct StorySelectionView: View {
    @StateObject private var viewModel = StoryGameViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var selectedStory: Story?
    
    var body: some View {
        NavigationView {
            ZStack {
                // Karanlık arka plan
                Color.black
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        VStack(spacing: 12) {
                            Text("Hikaye Seçin")
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundStyle(Color(red: 1.0, green: 0.7, blue: 0.7))
                            
                            Text("İnteraktif hikayelerin keyfini çıkarın")
                                .font(.system(size: 16, design: .rounded))
                                .foregroundStyle(.white.opacity(0.7))
                        }
                        .padding(.top, 30)
                        
                        // Stories List
                        VStack(spacing: 20) {
                            ForEach(Story.sampleStories) { story in
                                StoryCardView(story: story) {
                                    selectedStory = story
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Kapat") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
        }
        .fullScreenCover(item: $selectedStory) { story in
            StoryGameView()
                .onAppear {
                    viewModel.selectStory(story)
                }
        }
    }
}

struct StoryCardView: View {
    let story: Story
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 16) {
                // Story Title
                HStack {
                    Text(story.title)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.7))
                }
                
                // Story Description
                Text(story.description)
                    .font(.system(size: 16, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.leading)
                
                // Characters
                if !story.characters.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Karakterler:")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.7))
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(story.characters) { character in
                                    VStack(spacing: 4) {
                                        Text(character.name)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundStyle(.white.opacity(0.9))
                                        
                                        Text(character.role)
                                            .font(.system(size: 10))
                                            .foregroundStyle(.white.opacity(0.6))
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.white.opacity(0.1))
                                    .clipShape(Capsule())
                                }
                            }
                        }
                    }
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 0.15, green: 0.15, blue: 0.15))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    StorySelectionView()
}


//
//  TabuSettingsView.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import SwiftUI

struct TabuSettingsView: View {
    @StateObject private var viewModel = TabuGameViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingGame = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LiquidGlassBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 12) {
                            Text("🎭")
                                .font(.system(size: 60))
                            
                            Text("Tabu")
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundStyle(.primaryGradient)
                            
                            Text("Takım oyunu – yasaklı kelimeleri kullanmadan anlat!")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top)
                        
                        // Settings Card
                        VStack(spacing: 20) {
                            // Team Names
                            VStack(spacing: 16) {
                                Text("Takım İsimleri")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .foregroundStyle(.primary)
                                
                                VStack(spacing: 12) {
                                    CustomTextField(
                                        title: "Takım 1",
                                        text: $viewModel.team1Name,
                                        icon: "person.2.fill"
                                    )
                                    
                                    CustomTextField(
                                        title: "Takım 2",
                                        text: $viewModel.team2Name,
                                        icon: "person.2.fill"
                                    )
                                }
                            }
                            
                            Divider()
                                .background(.quaternary)
                            
                            // Game Settings
                            VStack(spacing: 16) {
                                Text("Oyun Ayarları")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .foregroundStyle(.primary)
                                
                                VStack(spacing: 16) {
                                    // Round Duration
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Image(systemName: "timer")
                                                .foregroundStyle(.blue)
                                            Text("Tur Süresi")
                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                            Spacer()
                                            Text("\(viewModel.roundDuration) saniye")
                                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                                .foregroundStyle(.blue)
                                        }
                                        
                                        Slider(
                                            value: Binding(
                                                get: { Double(viewModel.roundDuration) },
                                                set: { viewModel.roundDuration = Int($0) }
                                            ),
                                            in: 30...120,
                                            step: 15
                                        )
                                        .accentColor(.blue)
                                    }
                                    
                                    // Max Rounds
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Image(systemName: "repeat")
                                                .foregroundStyle(.green)
                                            Text("Toplam Tur")
                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                            Spacer()
                                            Text("\(viewModel.maxRounds) tur")
                                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                                .foregroundStyle(.green)
                                        }
                                        
                                        Slider(
                                            value: Binding(
                                                get: { Double(viewModel.maxRounds) },
                                                set: { viewModel.maxRounds = Int($0) }
                                            ),
                                            in: 2...10,
                                            step: 2
                                        )
                                        .accentColor(.green)
                                    }
                                }
                            }
                            
                            Divider()
                                .background(.quaternary)
                            
                            // Categories
                            VStack(spacing: 16) {
                                HStack {
                                    Image(systemName: "tag.fill")
                                        .foregroundStyle(.yellow)
                                    Text("Kategoriler")
                                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                                        .foregroundStyle(.primary)
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
                        
                        // Start Button
                        Button(action: {
                            showingGame = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "play.fill")
                                Text("Oyunu Başlat")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.primaryGradient)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .disabled(viewModel.selectedCategories.isEmpty)
                        .opacity(viewModel.selectedCategories.isEmpty ? 0.6 : 1.0)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
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
        .fullScreenCover(isPresented: $showingGame) {
            TabuGameView(viewModel: viewModel)
        }
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.blue)
                .frame(width: 20)
            
            TextField(title, text: $text)
                .font(.system(size: 16, weight: .medium, design: .rounded))
        }
        .padding()
        .background(.secondary.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct CategoryToggle: View {
    let category: String
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 8) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? .green : .secondary)
                
                Text(category)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(isSelected ? .primary : .secondary)
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? .green.opacity(0.1) : .secondary.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? .green.opacity(0.3) : .clear, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    TabuSettingsView()
}

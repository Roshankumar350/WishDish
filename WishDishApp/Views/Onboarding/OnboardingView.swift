//
//  OnboardingView.swift
//  WishDish
//
//  Created by Roshan Sah on 26/01/26.
//

import SwiftUI

struct OnboardingView: View {
    struct Constant {
        // Titles
        static let wishDishOnboarding = "WishDish Onboarding"
        static let welcomeTitle = "Welcome to WishDish"
        static let welcomeSubtitle = "Your smart companion for menus, moods, and invoices."
        static let menuSubtitle = "Browse and manage your menu items with ease."
        static let invoiceSubtitle = "Generate invoices instantly with tax and tip breakdowns."
        static let invoiceHint = "You’ll get a dedicated chat screen for each invoice, with clear breakdowns and details."
        static let moodSubtitle = "Add feedback and emojis to capture the dining experience."
        static let copyRight = "© 2026 WishDish. All rights reserved."
        
        // Buttons
        static let getStartedButton = "Get Started"
        static let exploreButton = "Let’s Explore Menu"
        
        // System Images
        static let menuIcon = "fork.knife"
        static let invoiceIcon = "doc.text"
        static let moodIcon = "face.smiling"
        static let sparkles = "sparkles"
        
        // Layout
        static let iconSize: CGFloat = 80
        static let bottomPadding: CGFloat = 40
        static let horizontalMargin: CGFloat = 20
        static let totalPages = 4
    }

    @State private var currentPage = 0
    var onFinish: () -> Void

    var body: some View {
        TabView(selection: $currentPage) {
            
            VStack(spacing: 24) {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: Constant.sparkles)
                        .font(.system(size: 28))
                        .foregroundColor(.accentColor)
                    Text(Constant.wishDishOnboarding)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Step 1 of \(Constant.totalPages)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }
                Spacer()
                VStack(spacing: 16) {
                    Text(Constant.welcomeTitle)
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    
                    Text(Constant.welcomeSubtitle)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                Spacer()
                Button(Constant.getStartedButton) {
                    currentPage = 1
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, Constant.horizontalMargin)
                .padding(.bottom, Constant.bottomPadding)
            }
            .frame(maxHeight: .infinity)
            .tag(0)
            
            VStack(spacing: 24) {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: Constant.sparkles)
                        .font(.system(size: 28))
                        .foregroundColor(.accentColor)
                    Text(Constant.wishDishOnboarding)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Step 2 of \(Constant.totalPages)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }
                Spacer()
                VStack(spacing: 16) {
                    Image(systemName: Constant.menuIcon)
                        .font(.system(size: Constant.iconSize))
                        .foregroundColor(.accentColor)
                        .padding()
                        .background(Circle().fill(Color.accentColor.opacity(0.1)))
                    
                    Text(Constant.menuSubtitle)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .tag(1)
            
            VStack(spacing: 24) {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: Constant.sparkles)
                        .font(.system(size: 28))
                        .foregroundColor(.accentColor)
                    Text(Constant.wishDishOnboarding)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Step 3 of \(Constant.totalPages)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }
                Spacer()
                VStack(spacing: 16) {
                    Image(systemName: Constant.invoiceIcon)
                        .font(.system(size: Constant.iconSize))
                        .foregroundColor(.accentColor)
                        .padding()
                        .background(Circle().fill(Color.accentColor.opacity(0.1)))
                    
                    Text(Constant.invoiceSubtitle)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    
                    Text(Constant.invoiceHint)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .tag(2)
            
            VStack(spacing: 24) {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: Constant.sparkles)
                        .font(.system(size: 28))
                        .foregroundColor(.accentColor)
                    Text(Constant.wishDishOnboarding)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Step 4 of \(Constant.totalPages)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }
                Spacer()
                VStack(spacing: 16) {
                    Image(systemName: Constant.moodIcon)
                        .font(.system(size: Constant.iconSize))
                        .foregroundColor(.accentColor)
                        .padding()
                        .background(Circle().fill(Color.accentColor.opacity(0.1)))
                    
                    Text(Constant.moodSubtitle)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                Spacer()
                Button(Constant.exploreButton) {
                    onFinish()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, Constant.horizontalMargin)
                
                Text(Constant.copyRight)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
                    .padding(.bottom, Constant.bottomPadding)
            }
            .frame(maxHeight: .infinity)
            .tag(3)
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .background(Color(.systemBackground))
    }
}



#Preview {
    OnboardingView(onFinish: {})
}

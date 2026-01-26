//
//  WishDishApp.swift
//  WishDish
//
//  Created by Roshan Sah on 08/10/25.
//

import SwiftUI

@main
struct WishDishApp: App {
    @State private var showOnboarding = !UserDefaults.standard.hasSeenOnboarding
    
    var body: some Scene {
        WindowGroup {
            if showOnboarding {
                OnboardingView {
                    UserDefaults.standard.hasSeenOnboarding = true
                    showOnboarding = false
                }
            } else {
                withAnimation(.smooth) {
                    RootTabView()
                }
               
            }
        }
    }
}

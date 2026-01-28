//
//  Userdefault+Settings.swift
//  WishDish
//
//  Created by Roshan Sah on 26/01/26.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let hasSeenOnboarding = "hasSeenOnboarding"
    }
    
    var hasSeenOnboarding: Bool {
        get { bool(forKey: Keys.hasSeenOnboarding) }
        set { set(newValue, forKey: Keys.hasSeenOnboarding) }
    }
}


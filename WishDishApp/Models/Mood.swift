//
//  Mood.swift
//  WishDish
//
//  Created by Roshan Sah on 09/10/25.
//

import Foundation

struct Mood: Identifiable {
    let id: UUID = UUID()
    let name: String
    let description: String
    let image: String
    let category: MoodCategory
}

enum MoodCategory: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case familyDining = "Family Dining"
    case drinkAndDine = "Drink and Dine"
    case premiumDining = "Premium Dining"
    case romanticDining = "Romantic Dining"
    case lightAndHealthy = "Light & Healthy"
    case quickBite = "Quick Bite"
    case vegetarianDelight = "Vegetarian Delight"
    case spicyAdventure = "Spicy Adventure"
    
    var categoryName: String {
        switch self {
        case .familyDining:
            return "Family Dining"
        case .drinkAndDine:
            return "Drink and Dine"
        case .premiumDining:
            return "Premium Dining"
        case .romanticDining:
            return "Romantic Dining"
        case .lightAndHealthy:
            return "Light & Healthy"
        case .quickBite:
            return "Quick Bite"
        case .vegetarianDelight:
            return "Vegetarian Delight"
        case .spicyAdventure:
            return "Spicy Adventure"
        }
    }
    
    var description: String {
        switch self {
        case .familyDining:
            return "Family-friendly dining options"
        case .drinkAndDine:
            return "Dining with a drink"
        case .premiumDining:
            return "High-end dining experiences"
        case .romanticDining:
            return "Romantic dining settings"
        case .quickBite:
            return "Quick and easy bites"
        case .vegetarianDelight:
            return "Vegetarian-friendly options"
        case .spicyAdventure:
            return "Spicy and adventurous dishes"
        case .lightAndHealthy:
            return "Light and healthy meals"
        }
    }
    
    var imageName: String {
        switch self {
        case .familyDining:
            return "familyDining"
        case .drinkAndDine:
            return "drinkAndDine"
        case .premiumDining:
            return "premiumDining"
        case .romanticDining:
            return "romanticDining"
        case .lightAndHealthy:
            return "lightAndHealthy"
        case .quickBite:
            return "quickBite"
        case .vegetarianDelight:
            return "vegetarianDelight"
        case .spicyAdventure:
            return "spicyAdventure"
        }
    }
}

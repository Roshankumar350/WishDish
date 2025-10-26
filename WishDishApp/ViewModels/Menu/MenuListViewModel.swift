//
//  MenuListViewModel.swift
//  WishDish
//
//  Created by Roshan Sah on 09/10/25.
//

import Combine
import Foundation

class MenuListViewModel {
    @Published var menuItems: [MenuItem]
    var selectedMood: MoodCategory?

    init(menuItems: [MenuItem], selectedMood: MoodCategory? = nil) {
        self.menuItems = menuItems
        self.selectedMood = selectedMood
    }
    
    func isSelectedMood() -> Bool {
        guard selectedMood != nil else { return false }
        return true
    }

    var selectedMoodItems: [MenuItem] {
        menuItems
    }

    var groupedByCategory: [String: [MenuItem]] {
        Dictionary(grouping: menuItems, by: { $0.category })
    }
}


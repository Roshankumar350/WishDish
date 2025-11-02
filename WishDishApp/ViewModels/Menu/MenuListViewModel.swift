//
//  MenuListViewModel.swift
//  WishDish
//
//  Created by Roshan Sah on 09/10/25.
//

import Combine
import Foundation

class MenuListViewModel {
    @Published var menuItems: [MenuList.MenuItem]
    var selectedMood: MoodCategory?

    init(menuItems: [MenuList.MenuItem], selectedMood: MoodCategory? = nil) {
        self.menuItems = menuItems
        self.selectedMood = selectedMood
    }
    
    func isSelectedMood() -> Bool {
        guard selectedMood != nil else { return false }
        return true
    }

    var selectedMoodItems: [MenuList.MenuItem] {
        menuItems
    }

    var groupedByCategory: [String: [MenuList.MenuItem]] {
        Dictionary(grouping: menuItems, by: { $0.category })
    }
}


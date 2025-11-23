//
//  MenuListViewModel.swift
//  WishDish
//
//  Created by Roshan Sah on 09/10/25.
//

import Combine
import Foundation

final class MenuListViewModel {
    // MARK: - Attributes
    /// Menu items
    @Published private var menuItems: [MenuList.MenuItem]

    init(menuItems: [MenuList.MenuItem]) {
        self.menuItems = menuItems
    }

    // MARK: - Behaviours
    
    /// Selected Menu items
    var selectedMoodItems: [MenuList.MenuItem] {
        menuItems
    }

    /// Menu item grouped by categories
    var groupedByCategory: [String: [MenuList.MenuItem]] {
        Dictionary(grouping: menuItems, by: { $0.category })
    }
}


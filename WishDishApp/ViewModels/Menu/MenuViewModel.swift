//
//  MenuViewModel.swift
//  WishDish
//
//  Created by Roshan Sah on 26/10/25.
//

import Foundation
import Combine

class MenuViewModel: ObservableObject {
    @Published var menuItems: [MenuList.MenuItem] = []
    let moodlist: [MoodCategory] = MoodCategory.allCases
    private let loader: ClientResourceLoading

    init(loader: ClientResourceLoading = ClientResourceLoader()) {
        self.loader = loader
        loadMenuItems()
    }

    func loadMenuItems() {
        do {
            menuItems = try loader.load(MenuList.self, from: "MenuList").items
        } catch {
            print("Menu loading failed: \(error)")
            menuItems = []
        }
    }
    
    var mineralWaterItem: MenuList.MenuItem? {
        menuItems.first(where: { $0.id == 100 })
    }

    func getMenuList(for mood: MoodCategory) -> [MenuList.MenuItem] {
        menuItems.filter { $0.category == mood.categoryName }
    }
    
    func getMoodBasedMenuItems(for selectedMood: MoodCategory?) -> [MenuList.MenuItem] {
        guard let mood = selectedMood else { return menuItems }
        return menuItems.filter { $0.category == mood.categoryName }
    }
    
    func getGroupedMenuItems(for selectedMood: MoodCategory?) -> [String: [MenuList.MenuItem]] {
        return Dictionary(grouping: getMoodBasedMenuItems(for: selectedMood), by: { $0.category })
    }
}



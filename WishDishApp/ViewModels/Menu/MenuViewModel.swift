//
//  MenuViewModel.swift
//  WishDish
//
//  Created by Roshan Sah on 26/10/25.
//

import Foundation
import Combine

class MenuViewModel: ObservableObject {
    @Published var menuItems: [MenuItem] = []
    let moodlist: [MoodCategory] = MoodCategory.allCases
    private let loader: ClientResourceLoading

    init(loader: ClientResourceLoading = ClientResourceLoader()) {
        self.loader = loader
        loadMenuItems()
    }

    func loadMenuItems() {
        do {
            menuItems = try loader.load([MenuItem].self, from: "MenuList")
        } catch {
            print("Menu loading failed: \(error)")
            menuItems = []
        }
    }
    
    var mineralWaterItem: MenuItem? {
        menuItems.first(where: { $0.id == 100 })
    }

    func getMenuList(for mood: MoodCategory) -> [MenuItem] {
        menuItems.filter { $0.category == mood.categoryName }
    }
    
    func getMoodBasedMenuItems(for selectedMood: MoodCategory?) -> [MenuItem] {
        guard let mood = selectedMood else { return menuItems }
        return menuItems.filter { $0.category == mood.categoryName }
    }
    
    func getGroupedMenuItems(for selectedMood: MoodCategory?) -> [String: [MenuItem]] {
        return Dictionary(grouping: getMoodBasedMenuItems(for: selectedMood), by: { $0.category })
    }
}



//
//  MenuViewModel.swift
//  WishDish
//
//  Created by Roshan Sah on 26/10/25.
//

import Foundation
import Combine

final class MenuViewModel: ObservableObject {
    // MARK: - Attributes
    @Published var menuItems: [MenuList.MenuItem] = []
    let moodlist: [MoodCategory] = MoodCategory.allCases
    private let loader: ClientResourceLoading

    init(loader: ClientResourceLoading = ClientResourceLoader()) {
        self.loader = loader
        if loadAychronously {
            Task {
                await loadAsyncMenuItems()
            }
        } else {
            loadMenuItems()
        }
    }
    
    // MARK: - Behaviours
    
    /// Synchronous resource loading
    private func loadMenuItems() {
        do {
            menuItems = try loader.load(MenuList.self, from: "MenuList").items
        } catch {
            print("Menu loading failed: \(error)")
            menuItems = []
        }
    }
    
    /// Asynchronous resource loading
    private func loadAsyncMenuItems() async {
        do {
            let menuList = try await loader.loadAsync(MenuList.self, from: "http://localhost:8000/api/menu")
            await MainActor.run {
                self.menuItems = menuList.items
            }
        } catch {
            debugPrint("Menu loading failed: \(error)")
            await MainActor.run {
                self.menuItems = []
            }
        }
    }
    
    /// Mineral water item
    /// Note: We are identifying water with its id
    var mineralWaterItem: MenuList.MenuItem? {
        menuItems.first(where: { $0.id == 100 })
    }
    
    /// Getting menu list or mood based menu list
    func getMoodBasedMenuItems(for selectedMood: MoodCategory?) -> [MenuList.MenuItem] {
        guard let mood = selectedMood else { return menuItems }
        return menuItems.filter { $0.category == mood.categoryName }
    }
    
    /// Grouped based menu list or mood based menu list
    func getGroupedMenuItems(for selectedMood: MoodCategory?) -> [String: [MenuList.MenuItem]] {
        return Dictionary(grouping: getMoodBasedMenuItems(for: selectedMood), by: { $0.category })
    }
}



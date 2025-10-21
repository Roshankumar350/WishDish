//
//  TabViewModel.swift
//  WishDish
//
//  Created by Roshan Sah on 12/10/25.
//

import Combine
import Foundation
// TODO: - [NOTE]: This is used to toggle async and sync call 
let loadAychronously: Bool = true

class TabViewModel: ObservableObject {
    @Published var menuItems: [MenuItem] = []
    private(set) var moodlist: [MoodCategory] = MoodCategory.allCases
    @Published var currentOrder: Order?
    @Published var mineralWaterQuantity: Int = 0
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
    
    func loadMenuItems() {
        do {
            menuItems = try loader.load([MenuItem].self, from: "MenuList")
        } catch {
            debugPrint("Menu loading failed: \(error)")
            menuItems = []
        }
    }
    
    func loadAsyncMenuItems() async {
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

    
    func getMenuListBasedOnMood(mood: MoodCategory) -> [MenuItem] {
        return menuItems.filter { $0.category == mood.categoryName }
    }
}

extension TabViewModel {
    var groupedByCategory: [String: [MenuItem]] {
        Dictionary(grouping: menuItems, by: { $0.category })
    }
    
    var selectedItems: [MenuItem] {
        menuItems.filter { $0.quantity > 0 }
    }
    
    var selectedItemsWithWater: [MenuItem] {
        var items = selectedItems
        if mineralWaterQuantity > 0,
           var water = menuItems.first(where: { $0.name == "Mineral Water" }) {
            water.quantity = mineralWaterQuantity
            items.append(water)
        }
        return items
    }
    
    func incrementQuantity(for item: MenuItem) {
        guard let index = menuItems.firstIndex(where: { $0.id == item.id }) else { return }
        var updatedItem = menuItems[index]
        updatedItem.quantity += 1
        menuItems[index] = updatedItem
    }
    
    func decrementQuantity(for item: MenuItem) {
        guard let index = menuItems.firstIndex(where: { $0.id == item.id }) else { return }
        var updatedItem = menuItems[index]
        updatedItem.quantity = max(0, updatedItem.quantity - 1)
        menuItems[index] = updatedItem
    }
    
    func incrementMineralWater() {
        mineralWaterQuantity += 1
    }
    
    func decrementMineralWater() {
        if mineralWaterQuantity > 0 {
            mineralWaterQuantity -= 1
        }
    }
    
    func clearSelectedItems() {
        for index in menuItems.indices {
            var item = menuItems[index]
            item.quantity = 0
            menuItems[index] = item
        }
    }
}

// MARK: - Order
extension TabViewModel {
    // This is done for demo purpose only
    var byPassAverageWaitTime: Bool {
        return true
    }
    
    func averagePreprationTime(for items: [MenuItem]) -> Int {
        guard !items.isEmpty else { return 0 }
        let totalTime = items.reduce(0) { $0 + $1.prepTimeMinutes }
        return totalTime / items.count
    }
    
    func confirmOrder() {
        let selectedItems = selectedItemsWithWater
        let averageWaitTime = averagePreprationTime(for: selectedItems)
        currentOrder = Order(id: UUID(),
                             items: selectedItems,
                             timestamp: Date(),
                             status: .preparing,
                             estimatedWaitMinutes: byPassAverageWaitTime ? 1 :  averageWaitTime)
    }
    
    func updateOrderStatus(to: OrderStatus) {
        currentOrder?.status = to
    }
}

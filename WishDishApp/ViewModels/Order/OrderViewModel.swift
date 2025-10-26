//
//  OrderViewModel.swift
//  WishDish
//
//  Created by Nidhi Kumari on 26/10/25.
//

import Foundation
import Combine

class OrderViewModel: ObservableObject {
    @Published var currentOrder: Order?
    @Published var mineralWaterQuantity: Int = 0
    @Published var selectedItems: [MenuItem] = []

    func incrementQuantity(for item: MenuItem) {
        updateItem(item, delta: +1)
    }

    func decrementQuantity(for item: MenuItem) {
        updateItem(item, delta: -1)
    }

    private func updateItem(_ item: MenuItem, delta: Int) {
        if let index = selectedItems.firstIndex(where: { $0.id == item.id }) {
            let updated = selectedItems[index].withUpdatedQuantity(max(0, selectedItems[index].quantity + delta))
            selectedItems[index] = updated
        } else if delta > 0 {
            selectedItems.append(item.withUpdatedQuantity(delta))
        }
    }

    func incrementMineralWater() {
        mineralWaterQuantity += 1
    }

    func decrementMineralWater() {
        mineralWaterQuantity = max(0, mineralWaterQuantity - 1)
    }

    var selectedItemsWithWater: [MenuItem] {
        var items = selectedItems
        if mineralWaterQuantity > 0,
           let water = selectedItems.first(where: { $0.name == "Mineral Water" }) {
            items.append(water.withUpdatedQuantity(mineralWaterQuantity))
        }
        return items
    }

    func confirmOrder() {
        let items = selectedItemsWithWater
        let avgTime = averagePrepTime(for: items)
        currentOrder = Order(id: UUID(), items: items, timestamp: Date(), status: .preparing, estimatedWaitMinutes: avgTime)
    }
    
    func updateOrderStatus(to newStatus: OrderStatus) {
        guard var order = currentOrder else { return }
        order.status = newStatus
        currentOrder = order
    }
    
    func quantity(for item: MenuItem) -> Int {
        selectedItems.first(where: { $0.id == item.id })?.quantity ?? 0
    }


    func averagePrepTime(for items: [MenuItem]) -> Int {
        guard !items.isEmpty else { return 0 }
        return items.reduce(0) { $0 + $1.prepTimeMinutes } / items.count
    }

    func clearOrder() {
        selectedItems = []
        mineralWaterQuantity = 0
        currentOrder = nil
    }
}



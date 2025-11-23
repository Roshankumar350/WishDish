//
//  OrderViewModel.swift
//  WishDish
//
//  Created by Roshan Sah on 26/10/25.
//

import Foundation
import Combine

final class OrderViewModel: ObservableObject {
    // MARK: - Attributes
    @Published private(set) var currentOrder: Order?
    @Published private(set) var mineralWaterQuantity: Int = 0
    @Published private(set) var selectedItems: [MenuList.MenuItem] = []
    @Published private(set) var elapsedSeconds: Int = 0
    @Published private(set) var remainingTime: Int = 0

    private var cancellable: AnyCancellable?
    
    private(set) var menuVM: MenuViewModel? = nil

    // MARK: - Behaviours
    /// Setting Menu Viewmodel
    func setMenuViewModel(_ menuVM: MenuViewModel) {
        self.menuVM = menuVM
    }
    
    /// Increment Mune item by 1
    func incrementQuantity(for item: MenuList.MenuItem) {
        updateItem(item, delta: +1)
    }

    /// Decrement Mune item by 1
    func decrementQuantity(for item: MenuList.MenuItem) {
        updateItem(item, delta: -1)
    }
    
    /// Increment water  item by 1
    func incrementMineralWater() {
        mineralWaterQuantity += 1
    }

    /// Decrement water  item by 1
    func decrementMineralWater() {
        mineralWaterQuantity = max(0, mineralWaterQuantity - 1)
    }

    // Helper
    private func updateItem(_ item: MenuList.MenuItem, delta: Int) {
        if let index = selectedItems.firstIndex(where: { $0.id == item.id }) {
            let newQuantity = max(0, selectedItems[index].quantity + delta)
            if newQuantity == 0 {
                selectedItems.remove(at: index)
            } else {
                selectedItems[index] = selectedItems[index].withUpdatedQuantity(newQuantity)
            }
        } else if delta > 0 {
            selectedItems.append(item.withUpdatedQuantity(delta))
        }
    }
    
    // Deinitialisation
    deinit {
        stopTimer()
        debugPrint("OrderViewModel deallocated")
    }
}

// MARK: - Orders Behaviour
extension OrderViewModel {
    
    /// subtotal of current order
    var subtotal: Double {
        currentOrder?.items.reduce(0) { $0 + Double($1.quantity) * $1.price } ?? 0
    }

    /// Order confirmation
    var selectedItemsWithWater: [MenuList.MenuItem] {
        var items = selectedItems
        if mineralWaterQuantity > 0,
           let water = menuVM?.mineralWaterItem {
            items.append(water.withUpdatedQuantity(mineralWaterQuantity))
        }
        return items
    }
    
    /// Order confirmation
    func confirmOrder() {
        let items = selectedItemsWithWater
        let avgTime = averagePrepTime(for: items)
        currentOrder = Order(id: UUID(), items: items, timestamp: Date(), status: .preparing, estimatedWaitMinutes: byPassAverageWaitTime ? 1 : avgTime)
    }
    
    /// Order status update
    func updateOrderStatus(to newStatus: OrderStatus) {
        guard var order = currentOrder else { return }
        order.status = newStatus
        currentOrder = order
    }
    
    /// Average prepration time
    func averagePrepTime(for items: [MenuList.MenuItem]) -> Int {
        guard !items.isEmpty else { return 0 }
        return items.reduce(0) { $0 + $1.prepTimeMinutes } / items.count
    }
    
    /// clear the order
    func clearOrder() {
        selectedItems = []
        mineralWaterQuantity = 0
        currentOrder = nil
        resetTimerAndAssociatedValues()
    }
}

// MARK: Timer Behaviour
extension OrderViewModel {
    /// Start timer
    func startTimer() {
        guard cancellable == nil else { return }
        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    private func tick() {
        guard let order = currentOrder, order.status != .served else { return }
        
        elapsedSeconds += 1
        remainingTime = max(order.estimatedWaitMinutes - (elapsedSeconds / 60), 0)
        
        if remainingTime == 0 && order.status != .ready {
            updateOrderStatus(to: .ready)
        }
    }
    /// Stop timer
    func stopTimer() {
        cancellable?.cancel()
        cancellable = nil
    }
    
    /// Reset the timer
    func resetTimerAndAssociatedValues() {
        stopTimer()
        elapsedSeconds = 0
        remainingTime = 0
    }

}

// MARK: Progress View Behaviour
extension OrderViewModel {
    /// Progress bar fraction
    var progressFraction: Double {
        guard let order = currentOrder else { return 0 }
        let totalWaitSeconds = max(order.estimatedWaitMinutes * 60, 1)
        return min(Double(elapsedSeconds) / Double(totalWaitSeconds), 1.0)
    }

}

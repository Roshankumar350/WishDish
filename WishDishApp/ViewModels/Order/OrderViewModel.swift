//
//  OrderViewModel.swift
//  WishDish
//
//  Created by Roshan Sah on 26/10/25.
//

import Foundation
import Combine

class OrderViewModel: ObservableObject {
    @Published var currentOrder: Order?
    @Published var mineralWaterQuantity: Int = 0
    @Published var selectedItems: [MenuList.MenuItem] = []
    @Published var elapsedSeconds: Int = 0
    @Published var remainingTime: Int = 0

    private var cancellable: AnyCancellable?
    
    var menuVM: MenuViewModel? = nil

    func incrementQuantity(for item: MenuList.MenuItem) {
        updateItem(item, delta: +1)
    }

    func decrementQuantity(for item: MenuList.MenuItem) {
        updateItem(item, delta: -1)
    }
    
    func incrementMineralWater() {
        mineralWaterQuantity += 1
    }

    func decrementMineralWater() {
        mineralWaterQuantity = max(0, mineralWaterQuantity - 1)
    }

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
    
    func quantity(for item: MenuList.MenuItem) -> Int {
        selectedItems.first(where: { $0.id == item.id })?.quantity ?? 0
    }
    
    deinit {
        stopTimer()
        debugPrint("OrderViewModel deallocated")
    }
}

// MARK: - Orders Behaviour
extension OrderViewModel {
    // This is done for demo purpose only
    var byPassAverageWaitTime: Bool {
        return true
    }
    
    var subtotal: Double {
        currentOrder?.items.reduce(0) { $0 + Double($1.quantity) * $1.price } ?? 0
    }

    var selectedItemsWithWater: [MenuList.MenuItem] {
        var items = selectedItems
        if mineralWaterQuantity > 0,
           let water = menuVM?.mineralWaterItem {
            items.append(water.withUpdatedQuantity(mineralWaterQuantity))
        }
        return items
    }
    
    func confirmOrder() {
        let items = selectedItemsWithWater
        let avgTime = averagePrepTime(for: items)
        currentOrder = Order(id: UUID(), items: items, timestamp: Date(), status: .preparing, estimatedWaitMinutes: byPassAverageWaitTime ? 1 : avgTime)
    }
    
    func updateOrderStatus(to newStatus: OrderStatus) {
        guard var order = currentOrder else { return }
        order.status = newStatus
        currentOrder = order
    }
    
    func clearOrder() {
        selectedItems = []
        mineralWaterQuantity = 0
        currentOrder = nil
        resetTimerAndAssociatedValues()
    }
    
    func averagePrepTime(for items: [MenuList.MenuItem]) -> Int {
        guard !items.isEmpty else { return 0 }
        return items.reduce(0) { $0 + $1.prepTimeMinutes } / items.count
    }
}

// MARK: Timer Behaviour
extension OrderViewModel {
    func startTimer() {
        guard cancellable == nil else { return }
        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    func tick() {
        guard let order = currentOrder, order.status != .served else { return }
        
        elapsedSeconds += 1
        remainingTime = max(order.estimatedWaitMinutes - (elapsedSeconds / 60), 0)
        
        if remainingTime == 0 && order.status != .ready {
            updateOrderStatus(to: .ready)
        }
    }
    
    func stopTimer() {
        cancellable?.cancel()
        cancellable = nil
    }
    
    func resetTimerAndAssociatedValues() {
        stopTimer()
        elapsedSeconds = 0
        remainingTime = 0
    }

}

// MARK: Progress View Behaviour
extension OrderViewModel {
    var progressFraction: Double {
        guard let order = currentOrder else { return 0 }
        let totalWaitSeconds = max(order.estimatedWaitMinutes * 60, 1)
        return min(Double(elapsedSeconds) / Double(totalWaitSeconds), 1.0)
    }

}

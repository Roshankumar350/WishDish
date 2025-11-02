//
//  Order.swift
//  WishDish
//
//  Created by Roshan Sah on 13/10/25.
//

import Foundation

struct Order: Identifiable, Decodable {
    let id: UUID
    let items: [MenuList.MenuItem]
    let timestamp: Date
    var status: OrderStatus
    var estimatedWaitMinutes: Int
}

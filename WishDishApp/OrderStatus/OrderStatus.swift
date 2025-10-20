//
//  OrderStatus.swift
//  WishDish
//
//  Created by Roshan Sah on 13/10/25.
//

import Foundation

enum OrderStatus: String, Codable {
    case confirmed
    case preparing
    case ready
    case served

    var displayText: String {
        switch self {
        case .confirmed: return "Order Confirmed"
        case .preparing: return "Preparing"
        case .ready: return "Ready to Serve"
        case .served: return "Served"
        }
    }

    var icon: String {
        switch self {
        case .confirmed: return "checkmark.circle"
        case .preparing: return "hourglass"
        case .ready: return "bell"
        case .served: return "fork.knife"
        }
    }
}

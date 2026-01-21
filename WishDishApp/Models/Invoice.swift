//
//  Invoice.swift
//  WishDish
//
//  Created by Roshan Sah on 12/10/25.
//

import Foundation

struct Invoice: Identifiable {
    let id: UUID
    let date: Date
    let items: [MenuList.MenuItem]
    let totalAmount: Double
    let tip: Double
    let feedback: String?
}

extension Invoice {
    var sgst: Double {
        (totalAmount - tip) * 0.09
    }

    var cgst: Double {
        (totalAmount - tip) * 0.09
    }

    var subtotal: Double {
        totalAmount - tip - sgst - cgst
    }
}

struct InvoiceComponent: Identifiable {
    let id = UUID()
    let label: String
    let amount: Double
}

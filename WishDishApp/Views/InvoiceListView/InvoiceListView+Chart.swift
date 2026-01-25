//
//  InvoiceListView+Chart.swift
//  WishDish
//
//  Created by Roshan Sah on 17/01/26.
//

import SwiftUI
import Charts
 
extension InvoiceListView {
    struct InvoiceCircularChart: View {
        var rawComponents: [InvoiceComponent] = []
        
        var total: Double {
            rawComponents.reduce(0) { $0 + $1.amount }
        }
        
        var invoiceBreakdown: [(component: InvoiceComponent, percent: Double)] {
            rawComponents.map { component in
                let percent = total == 0 ? 0 : (component.amount / total) * 100
                return (component, percent)
            }
        }
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Total amount spent ₹ \(total, specifier: "%.2f")")
                    .sectionHeaderText()
                    .padding()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(rawComponents) { item in
                            ItemCardView(name: item.label, price: item.amount)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Chart(invoiceBreakdown, id: \.component.id) { item in
                    SectorMark(
                        angle: .value("Amount", item.component.amount),
                        innerRadius: .ratio(0.2),
                        outerRadius: .ratio(1.0)
                    )
                    .foregroundStyle(by: .value("Label", item.component.label))
                    .annotation(position: .overlay) {
                        if item.percent > 1 {
                            Text("\(String(format: "%.1f", item.percent))%")
                                .font(.caption2)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
                Spacer()
            }
        }
    }
    
    struct ItemCardView: View {
        let name: String
        let price: Double
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("₹ \(price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(width: 180, height: 100)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .shadow(radius: 2)
        }
    }

    
}

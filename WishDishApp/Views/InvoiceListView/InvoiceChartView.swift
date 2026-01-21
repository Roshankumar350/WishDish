//
//  InvoiceChartView.swift
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
            VStack {
                Text(Constant.yourInvoicesSummery)
                    .modifier(SectionHeaderStyle())
                    .padding()
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
}

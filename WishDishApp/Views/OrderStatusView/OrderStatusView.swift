//
//  OrderStatusView.swift
//  WishDish
//
//  Created by Roshan Sah on 13/10/25.
//

import SwiftUI
import Combine

struct OrderStatusView: View {
    @ObservedObject var orderVM: OrderViewModel
    @StateObject var invoiceViewModel = InvoiceViewModel()
    @State private var showInvoiceView = false
    @Binding var selectedTab: Int

    var body: some View {
        VStack(spacing: 20) {
            if let order = orderVM.currentOrder {
                let subtotal = order.items.reduce(0) { $0 + Double($1.quantity) * $1.price }

                Text(order.status.displayText)
                    .customTextStyle(font: .title, weight: .bold)

                Image(systemName: order.status.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)

                Text("Estimated wait: \(orderVM.remainingTime) min")
                    .customTextStyle(font: .headline, color: .secondary)

                let totalWaitSeconds = max(order.estimatedWaitMinutes * 60, 1)
                let progressFraction = Double(orderVM.elapsedSeconds) / Double(totalWaitSeconds)

                ProgressView(value: min(progressFraction, 1.0))
                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
                    .padding(.horizontal)

                List(order.items) { item in
                    HStack {
                        Text("\(item.name) x \(item.quantity)")
                        Spacer()
                        Text("₹\(Double(item.quantity) * item.price, specifier: "%.2f")")
                            .customTextStyle(font: .footnote, weight: .semibold)
                    }
                }
                Divider()
                    .padding(.horizontal)

                VStack(spacing: 8) {
                    HStack {
                        Text("Total Amount")
                            .font(.headline)
                        Spacer()
                        Text("₹\(subtotal, specifier: "%.2f")")
                            .font(.headline)
                            .bold()
                    }
                }
                .padding(.horizontal)

                if order.status != .served {
                    Button("Mark as Served") {
                        orderVM.updateOrderStatus(to: .served)
                        showInvoiceView = true
                        selectedTab = 3
                    }
                    .primaryButtonStyle()
                    .navigationDestination(isPresented: $showInvoiceView) {
                        AddInvoiceView(
                            viewModel: invoiceViewModel,
                            orderVM: orderVM,
                            selectedTab: $selectedTab
                        ) 
                    }
                }
            } else {
                Text("No active order")
                    .customTextStyle(font: .title2, color: .gray)
            }
        }
        .padding()
        .onAppear {
            orderVM.startTimer()
        }
        .onDisappear {
            orderVM.resetTimerAndAssociatedValues()
        }
        .navigationTitle("Order Status")
    }
}

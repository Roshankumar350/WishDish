//
//  OrderStatusView.swift
//  WishDish
//
//  Created by Roshan Sah on 13/10/25.
//

import SwiftUI
import Combine

struct OrderStatusView: View {
    struct Constant {
        static let totalAmout = "Total Amount"
        static let markedServed = "Mark as Served"
        static let noActiveOrder = "No active order"
        static let orderStatus = "Order Status"
        static let estimatedWait = "Estimated wait:"
    }
    
    @ObservedObject var orderVM: OrderViewModel
    @StateObject var invoiceViewModel = InvoiceViewModel()
    @State private var showInvoiceView = false
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(spacing: 20) {
            if let order = orderVM.currentOrder {
                Text(order.status.displayText)
                    .customTextStyle(font: .title, weight: .bold)

                Image(systemName: order.status.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)

                Text("\(Constant.estimatedWait) \(orderVM.remainingTime) min")
                    .customTextStyle(font: .headline, color: .secondary)

                ProgressView(value: orderVM.progressFraction)
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
                        Text(Constant.totalAmout)
                            .font(.headline)
                        Spacer()
                        Text("₹\(orderVM.subtotal, specifier: "%.2f")")
                            .font(.headline)
                            .bold()
                    }
                }
                .padding(.horizontal)

                if order.status != .served {
                    Button(Constant.markedServed) {
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
                Text(Constant.noActiveOrder)
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
        .navigationTitle(Constant.orderStatus)
    }
}

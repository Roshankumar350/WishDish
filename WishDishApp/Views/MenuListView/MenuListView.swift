//
//  MenuListView.swift
//  WishDish
//
//  Created by Roshan Sah on 09/10/25.
//

import Combine
import SwiftUI

struct MenuListView: View {
    @ObservedObject var menuVM: MenuViewModel
    @ObservedObject var orderVM: OrderViewModel
    @ObservedObject var invoiceViewModel: InvoiceViewModel
    @Binding var selectedTab: Int
    @State var selectedMood: MoodCategory?
    @State private var showOrderStatus = false

    struct Constant {
        static let whatsCookingForTitle = "What's Cooking for"
        static let yourDiningMenuTitle = "Your Dining Menu"
    }

    var body: some View {
        VStack {
            if showOrderStatus {
                OrderStatusView(
                    orderVM: orderVM,
                    invoiceViewModel: invoiceViewModel,
                    selectedTab: $selectedTab
                )
                .navigationBarBackButtonHidden(true)
            } else {
                MenuListContent(
                    orderVM: orderVM,
                    selectedMood: selectedMood,
                    filteredItems: menuVM.getMoodBasedMenuItems(for: selectedMood),
                    groupedItems: menuVM.getGroupedMenuItems(for: selectedMood)
                )

                MineralWaterControls(orderVM: orderVM) {
                    orderVM.confirmOrder()
                    showOrderStatus = true
                }
            }
        }
        .navigationTitle(selectedMood != nil ? "\(Constant.whatsCookingForTitle) \(selectedMood!.categoryName)?" : Constant.yourDiningMenuTitle)
        .onChange(of: selectedTab) {
            showOrderStatus = false
        }
    }
}

extension MenuListView {
    struct MenuListViewConstant {
        static let extras = "Extras"
    }

    struct MenuListContent: View {
        @ObservedObject var orderVM: OrderViewModel
        let selectedMood: MoodCategory?
        let filteredItems: [MenuList.MenuItem]
        let groupedItems: [String: [MenuList.MenuItem]]

        var body: some View {
            List {
                if selectedMood == nil {
                    ForEach(filteredItems) { item in
                        if item.category == MenuListViewConstant.extras {
                            Section(header: Text(MenuListViewConstant.extras).sectionHeaderText()) {
                                MenuRow(orderVM: orderVM, item: item)
                            }
                        } else {
                            MenuRow(orderVM: orderVM, item: item)
                        }
                    }
                } else {
                    ForEach(groupedItems.keys.sorted(), id: \.self) { category in
                        Section(header: Text(category).font(.title2).bold()) {
                            ForEach(groupedItems[category] ?? []) { item in
                                MenuRow(orderVM: orderVM, item: item)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension MenuListView {
    struct MenuRow: View {
        @ObservedObject var orderVM: OrderViewModel
        let item: MenuList.MenuItem

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center, spacing: 12) {
                    MenuImageView(imageName: item.moodCategory.imageName)

                    Text(item.name)
                        .titleText()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Text(item.description)
                    .bodyText()

                Text("₹\(item.price, specifier: "%.2f")")
                    .priceText()

                if !item.dietaryFlags.isEmpty {
                    Text(item.dietaryFlags.joined(separator: ", "))
                        .dietaryInfoText()
                }

                StepperView(item: item, orderVM: orderVM)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
}


extension MenuListView {
    struct StepperView: View {
        struct StepperViewConstant {
            static let quantity = "Quantity:"
            static let added = "Added"
        }

        let item: MenuList.MenuItem
        @ObservedObject var orderVM: OrderViewModel

        var body: some View {
            let quantity = orderVM.selectedItems.first(where: { $0.id == item.id })?.quantity ?? 0

            Stepper {
                HStack {
                    Text("\(StepperViewConstant.quantity) \(quantity)")
                        .font(.headline)

                    if quantity > 0 {
                        Text(StepperViewConstant.added)
                            .captionText()
                            .foregroundColor(.green)
                            .transition(.opacity)
                    }
                }
            } onIncrement: {
                orderVM.incrementQuantity(for: item)
            } onDecrement: {
                orderVM.decrementQuantity(for: item)
            }
            .padding(.top, 8)
        }
    }
}


extension MenuListView {
    struct MineralWaterControls: View {
        struct MineralWaterControlsConstant {
            static let mineralWater = "Mineral Water (₹30 each)"
            static let minusCircle = "minus.circle.fill"
            static let plusCircle = "plus.circle.fill"
            static let added = "Added"
            static let confirmOrder = "Confirm Order"
        }

        @ObservedObject var orderVM: OrderViewModel
        var confirmAction: () -> Void

        var body: some View {
            VStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(MineralWaterControlsConstant.mineralWater).bodyText()

                    HStack(spacing: 16) {
                        Button {
                            withAnimation {
                                orderVM.decrementMineralWater()
                            }
                        } label: {
                            Image(systemName: MineralWaterControlsConstant.minusCircle)
                                .font(.title2)
                                .foregroundColor(.red)
                        }

                        Text("\(orderVM.mineralWaterQuantity)")
                            .font(.headline)
                            .frame(width: 32)

                        Button {
                            withAnimation {
                                orderVM.incrementMineralWater()
                            }
                        } label: {
                            Image(systemName: MineralWaterControlsConstant.plusCircle)
                                .font(.title2)
                                .foregroundColor(.green)
                        }

                        Spacer()

                        if orderVM.mineralWaterQuantity > 0 {
                            Text(MineralWaterControlsConstant.added)
                                .captionText()
                                .foregroundColor(.green)
                                .transition(.opacity)
                        }
                    }
                }
                .padding(.horizontal)

                if !orderVM.selectedItems.isEmpty || orderVM.mineralWaterQuantity > 0 {
                    Button(MineralWaterControlsConstant.confirmOrder) {
                        confirmAction()
                    }
                    .primaryButtonStyle()
                    .transition(.opacity.combined(with: .scale))
                }
            }
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            .animation(.easeInOut(duration: 0.3), value: orderVM.selectedItems.count + orderVM.mineralWaterQuantity)
        }
    }
}




extension MenuListView {
    struct MenuImageView: View {
        let imageName: String

        var body: some View {
            Image(imageName)
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(width: 60, height: 60)
                .cornerRadius(8)
                .shadow(radius: 2)
                .clipped()
        }
    }
}

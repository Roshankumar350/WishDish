//
//  MenuListView.swift
//  WishDish
//
//  Created by Roshan Sah on 09/10/25.
//

import Combine
import SwiftUI

struct MenuListView: View {
    @ObservedObject var viewModel: TabViewModel
    @ObservedObject var invoiceViewModel: InvoiceViewModel
    @Binding var selectedTab: Int
    @State var selectedMood: MoodCategory?
    @State private var showOrderStatus = false
    
    struct Constant {
        static let whatsCookingForTitle = "What's Cooking for"
        static let yourDinigMenuTitle = "Your Dining Menu"
    }

    var filteredItems: [MenuItem] {
        guard let mood = selectedMood else { return viewModel.menuItems }
        return viewModel.menuItems.filter { $0.category == mood.categoryName }
    }

    var groupedItems: [String: [MenuItem]] {
        Dictionary(grouping: filteredItems, by: { $0.category })
    }

    var body: some View {
        VStack {
            if showOrderStatus {
                OrderStatusView(
                    viewModel: viewModel,
                    invoiceViewModel: invoiceViewModel,
                    selectedTab: $selectedTab
                )
            } else {
                MenuListContent(
                    viewModel: viewModel,
                    selectedMood: selectedMood,
                    filteredItems: filteredItems,
                    groupedItems: groupedItems
                )

                MineralWaterControls(viewModel: viewModel) {
                    viewModel.confirmOrder()
                    showOrderStatus = true
                }
            }
        }
        .navigationTitle(selectedMood != nil ? "\(Constant.whatsCookingForTitle) \(selectedMood!.categoryName)?" : "\(Constant.yourDinigMenuTitle)")
        .onChange(of: selectedTab) {
            showOrderStatus = false
        }
    }
}

// MARK: - VIEWS
extension MenuListView {
    
    struct MenuListViewConstant {
        static let extras = "Extras"
    }
    
    struct MenuListContent: View {
        let viewModel: TabViewModel
        let selectedMood: MoodCategory?
        let filteredItems: [MenuItem]
        let groupedItems: [String: [MenuItem]]

        var body: some View {
            List {
                if selectedMood == nil {
                    ForEach(filteredItems) { item in
                        if item.category == MenuListViewConstant.extras {
                            Section(header: Text(MenuListViewConstant.extras).sectionHeaderText()) {
                                MenuRow(viewModel: viewModel, item: item)
                            }
                        } else {
                            MenuRow(viewModel: viewModel, item: item)
                        }
                    }
                } else {
                    ForEach(groupedItems.keys.sorted(), id: \.self) { category in
                        Section(header: Text(category).font(.title2).bold()) {
                            ForEach(groupedItems[category] ?? []) { item in
                                MenuRow(viewModel: viewModel, item: item)
                            }
                        }
                    }
                }
            }
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
        
        
        @ObservedObject var viewModel: TabViewModel
        var confirmAction: () -> Void

        var body: some View {
            VStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(MineralWaterControlsConstant.mineralWater).bodyText()

                    HStack(spacing: 16) {
                        Button {
                            viewModel.decrementMineralWater()
                        } label: {
                            Image(systemName: MineralWaterControlsConstant.minusCircle)
                                .font(.title2)
                                .foregroundColor(.red)
                        }

                        Text("\(viewModel.mineralWaterQuantity)")
                            .font(.headline)
                            .frame(width: 32)

                        Button {
                            viewModel.incrementMineralWater()
                        } label: {
                            Image(systemName: MineralWaterControlsConstant.plusCircle)
                                .font(.title2)
                                .foregroundColor(.green)
                        }

                        Spacer()

                        if viewModel.mineralWaterQuantity > 0 {
                            Text(MineralWaterControlsConstant.added)
                                .captionText()
                                .foregroundColor(.green)
                                .transition(.opacity)
                        }
                    }
                }
                .padding(.horizontal)

                if !viewModel.selectedItemsWithWater.isEmpty {
                    Button(MineralWaterControlsConstant.confirmOrder) {
                        confirmAction()
                    }
                    .primaryButtonStyle()
                }
            }
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
        }
    }

}

extension MenuListView {
    struct MenuRow: View {
        @ObservedObject var viewModel: TabViewModel
        let item: MenuItem
        
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
                
                StepperView(item: item, viewModel: viewModel)
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
        let item: MenuItem
        @ObservedObject var viewModel: TabViewModel
        
        var body: some View {
            Stepper {
                HStack {
                    Text("\(StepperViewConstant.quantity) \(item.quantity)")
                        .font(.headline)
                    
                    if item.quantity > 0 {
                        Text(StepperViewConstant.added)
                            .captionText()
                            .foregroundColor(.green)
                            .transition(.opacity)
                    }
                }
            } onIncrement: {
                viewModel.incrementQuantity(for: item)
            } onDecrement: {
                viewModel.decrementQuantity(for: item)
            }
            .padding(.top, 8)
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


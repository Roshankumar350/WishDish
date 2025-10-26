//
//  RootTabView.swift
//  WishDish
//
//  Created by Roshan Sah on 12/10/25.
//

//
//  RootTabView.swift
//  WishDish
//
//  Created by Roshan Sah on 12/10/25.
//

import SwiftUI

struct RootTabView: View {
    struct Constant {
        static let mood = "Mood"
        static let moodImage = "sparkles"
        static let menu = "Menu"
        static let menuImage = "menucard"
        static let invoice = "Invoice"
        static let invoiceImage = "doc.plaintext"
        static let addInvoice = "Add Invoice"
        static let addInvoiceImage = "plus.circle"
    }

    @StateObject var menuVM = MenuViewModel()
    @StateObject var orderVM = OrderViewModel()
    @StateObject var invoiceVM = InvoiceViewModel()
    @State private var selectedTab = 0
    @State private var resetPathTrigger = false

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                DiningCarnivalView(
                    menuVM: menuVM,
                    orderVM: orderVM,
                    selectedTab: $selectedTab,
                    invoiceViewModel: invoiceVM,
                    resetPathTrigger: $resetPathTrigger
                )
            }
            .tabItem { Label(Constant.mood, systemImage: Constant.moodImage) }
            .tag(0)

            NavigationStack {
                MenuListView(
                    menuVM: menuVM,
                    orderVM: orderVM,
                    invoiceViewModel: invoiceVM,
                    selectedTab: $selectedTab,
                    selectedMood: nil
                )
            }
            .tabItem { Label(Constant.menu, systemImage: Constant.menuImage) }
            .tag(1)

            NavigationStack {
                InvoiceListView(viewModel: invoiceVM)
            }
            .tabItem { Label(Constant.invoice, systemImage: Constant.invoiceImage) }
            .tag(2)

            NavigationStack {
                AddInvoiceView(
                    viewModel: invoiceVM,
                    orderVM: orderVM,
                    selectedTab: $selectedTab
                )
            }
            .tabItem { Label(Constant.addInvoice, systemImage: Constant.addInvoiceImage) }
            .tag(3)
        }
        .accentColor(.green)
        .onChange(of: selectedTab) {
            if selectedTab == 0 {
                resetPathTrigger.toggle()
            }
        }
    }
}

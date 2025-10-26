//
//  DiningCarnivalView.swift
//  WishDish
//
//  Created by Roshan Sah on 09/10/25.
//
import SwiftUI
import SwiftData

struct DiningCarnivalView: View {
    struct Constant {
        static let diningCarnival = "Dining Carnival"
        static let browseMood = "Browse our curated mood boards"
    }
    @ObservedObject var viewModel: RootTabViewModel
    @Binding var selectedTab: Int
    @ObservedObject var invoiceViewModel: InvoiceViewModel
    @State private var path = NavigationPath()
    @Binding var resetPathTrigger: Bool

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(Constant.diningCarnival)
                        .customTextStyle(font: .largeTitle, weight: .bold)
                        .sectionHeaderStyle()

                    Text(Constant.diningCarnival)
                        .customTextStyle(font: .headline, color: .secondary, padding: 4)
                        .sectionHeaderStyle()

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(viewModel.moodlist, id: \.self) { mood in
                            NavigationLink(value: mood) {
                                MoodTileView(mood: mood)
                            }
                            .accessibilityLabel("\(mood.categoryName) mood")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
                .padding(.top)
            }
            .navigationDestination(for: MoodCategory.self) { mood in
                MenuListView(
                    viewModel: viewModel,
                    invoiceViewModel: invoiceViewModel,
                    selectedTab: $selectedTab,
                    selectedMood: mood
                )
            }
        }
        .onChange(of: selectedTab) {
            if selectedTab == 0 {
                path = NavigationPath()
            }
        }
    }
}

extension DiningCarnivalView {
    struct MoodTileView: View {
        let mood: MoodCategory
        
        var body: some View {
            ZStack(alignment: .bottomLeading) {
                Image(mood.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
                    .cornerRadius(12)
                
                Text(mood.categoryName)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.25))
                    .cornerRadius(8)
                    .padding(8)
            }
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            .accessibilityElement(children: .combine)
        }
    }
}

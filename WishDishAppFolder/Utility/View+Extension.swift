//
//  View+Extension.swift
//  WishDish
//
//  Created by Roshan Sah on 19/10/25.
//

import SwiftUI

extension View {
    func cardStyle() -> some View {
        self.modifier(CardStyle())
    }

    func inputFieldStyle() -> some View {
        self.modifier(InputFieldStyle())
    }

    func primaryButtonStyle() -> some View {
        self.modifier(PrimaryButtonStyle())
    }

    func secondaryButtonStyle() -> some View {
        self.modifier(SecondaryButtonStyle())
    }
    
    func toastStyle() -> some View {
        self.modifier(ToastStyle())
    }
    
    func sectionHeaderStyle() -> some View {
        self.modifier(SectionHeaderStyle())
    }
    
    func moodLabel(_ text: String) -> some View {
        self.modifier(MoodLabelStyle(text: text))
    }
    
    func menuCardStyle() -> some View {
        self.modifier(MenuCardStyle())
    }
    
    func customTextStyle(
            font: Font = .body,
            color: Color = .primary,
            weight: Font.Weight = .regular,
            alignment: TextAlignment = .leading,
            padding: CGFloat? = nil
        ) -> some View {
            self.modifier(CustomTextStyle(
                font: font,
                color: color,
                weight: weight,
                alignment: alignment,
                padding: padding
            ))
        }
}

extension View {
    func titleText() -> some View {
        self.customTextStyle(font: .title2, weight: .bold)
    }

    func sectionHeaderText() -> some View {
        self.customTextStyle(font: .title3, weight: .semibold, padding: 4)
    }

    func bodyText() -> some View {
        self.customTextStyle(font: .body, color: .primary)
    }

    func captionText() -> some View {
        self.customTextStyle(font: .caption, color: .gray)
    }

    func priceText() -> some View {
        self.customTextStyle(font: .footnote, weight: .semibold)
    }

    func emptyStateText() -> some View {
        self.customTextStyle(font: .body, color: .secondary, alignment: .center, padding: 8)
    }

    func toastText() -> some View {
        self.customTextStyle(font: .headline, color: .white, alignment: .center)
    }
    
    // Tab bar labels like "Mood", "Menu", etc.
    func tabLabelText() -> some View {
        self.customTextStyle(font: .footnote, color: .gray, alignment: .center)
    }

    // Button text inside primary buttons
    func buttonText() -> some View {
        self.customTextStyle(font: .headline, color: .white, alignment: .center)
    }

    // Invoice details like "Date", "Items", "Total"
    func invoiceDetailText() -> some View {
        self.customTextStyle(font: .subheadline, color: .primary)
    }

    // Menu item dietary info
    func dietaryInfoText() -> some View {
        self.customTextStyle(font: .caption, color: .secondary)
    }
}

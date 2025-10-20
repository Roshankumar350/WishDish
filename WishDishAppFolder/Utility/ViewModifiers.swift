//
//  ViewModifiers.swift
//  WishDish
//
//  Created by Roshan Sah on 19/10/25.
//

import SwiftUI

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            .padding(.horizontal)
    }
}

struct InputFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
    }
}
struct PrimaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)
            .background(
                Color(.systemBackground)
                    .ignoresSafeArea(edges: .bottom)
            )
    }
}


struct SecondaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundColor(.blue)
    }
}

struct ToastStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.green.opacity(0.95))
            .cornerRadius(12)
            .shadow(radius: 10)
    }
}

struct SectionHeaderStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .padding(.horizontal)
    }
}

struct MoodLabelStyle: ViewModifier {
    let text: String

    func body(content: Content) -> some View {
        ZStack(alignment: .topLeading) {
            content

            Text(text)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.black.opacity(0.6))
                .cornerRadius(6)
                .padding([.top, .leading], 8)
        }
    }
}

struct MenuCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            .padding(.horizontal)
    }
}

struct CustomTextStyle: ViewModifier {
    var font: Font = .body
    var color: Color = .primary
    var weight: Font.Weight = .regular
    var alignment: TextAlignment = .leading
    var padding: CGFloat? = nil

    func body(content: Content) -> some View {
        Group {
            if let padding = padding {
                content
                    .font(font)
                    .foregroundColor(color)
                    .fontWeight(weight)
                    .multilineTextAlignment(alignment)
                    .padding(padding)
            } else {
                content
                    .font(font)
                    .foregroundColor(color)
                    .fontWeight(weight)
                    .multilineTextAlignment(alignment)
            }
        }
    }
}


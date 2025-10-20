# 🍽️ WishDish — Modular Restaurant Companion App

WishDish is a thoughtfully crafted restaurant app designed to digitize the menu experience, streamline order handoff, and enhance emotional clarity for both customers and staff. Built with SwiftUI and modular architecture, it emphasizes **menu browsing**, **invoice tracking**, and **real-time order status** — all without forcing transactional flow.

---

## 🚀 Features

- 🧾 **Digitized Menu Browsing**
  - Mood-based categories (e.g. Family Dining, Extras)
  - Quantity selection with steppers
  - Offline-style viewing with wishlist-style marking

- 📋 **Invoice Management**
  - View all invoices
  - Add new invoice with feedback and tip
  - Categorized billing (food, water, etc.)

- ⏱️ **Order Status Tracking**
  - Real-time progress bar based on elapsed time
  - Status transitions: Preparing → Ready → Served
  - Wait time estimation and visual feedback

- 💬 **Feedback & Tipping**
  - Emoji-based feedback
  - Optional tip entry
  - Emotional polish for user delight

- 🧭 **Tab-Based Navigation**
  - Custom tab bar with icons: Mood, Menu, Invoices, Add Invoice
  - Seamless transitions between views

---

## 🧱 Architecture

- **SwiftUI + MVVM**
  - Modular views and view models
  - Reactive state updates
  - Clean separation of UI and logic

- **Custom Components**
  - `OrderStatusView` with second-based progress updates
  - `InvoiceCreateView` with expressive feedback UI
  - Direct bundle image loading for mood icons and category visuals

- **Mock Data Support**
  - JSON-based mock loaders for testing
  - Decodable models with fallback handling

---

## 🧪 Testing

- ✅ Unit tests for decoding and subtotal logic  
- ✅ Mock JSON loading for menu items  
- ✅ Timer-driven progress simulation  
- ✅ UI validation for feedback and invoice creation

---

## 🛠️ Setup Instructions

1. Open `WishDish.xcodeproj` in Xcode 15+
2. Run on iPhone 17 Pro simulator (or any iOS 26+ device)
3. No external dependencies — pure SwiftUI

---

## 🎥 Demo Videos

Experience WishDish in action — modular SwiftUI architecture, mood-based browsing, and real-time order flow.

### 🌞 Light Mode
▶️ [Watch the demo](https://youtube.com/shorts/k0BMyg5lXBg?feature=share)

### 🌙 Dark Mode
▶️ [Watch the dark mode demo](https://youtube.com/shorts/qObuyOyVK2U?feature=share)



---

## 🧭 Future Enhancements

- Remote image loading with caching  
- Multi-order support for table management  
- Waiter handoff flow with QR or NFC  
- Analytics for popular items and feedback trends  
- **Accessibility improvements**  
  - VoiceOver support  
  - Dynamic type scaling  
  - High contrast and semantic clarity

- **Multilanguage support**  
  - Localized strings via `.strings` files  
  - Region-based menu customization  
  - RTL layout support for languages like Arabic or Hindi


---

## 👨‍🍳 Product Philosophy

WishDish is built to replicate the **offline menu experience**, allowing customers to browse, mark items, and notify waiters with minimal friction. It prioritizes **clarity**, **emotional resonance**, and **modular scalability**, making it ideal for both small cafés and large dining chains.

---

Crafted with care by Roshan Sah — bridging architecture, empathy, and delight.

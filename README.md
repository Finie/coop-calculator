# Loan Calculator – iOS (SwiftUI)

## Overview
- SwiftUI loan calculator that computes monthly payments and total payable amounts.
- Helps users calculate and review loan repayment summaries quickly.
- Features: loan calculation, repayment schedule preview, Core Data persistence, PDF export from details.

## Requirements
- macOS: Sonoma 14+ (recommended)
- Xcode: 16.x (or compatible with iOS 26.2 deployment target)
- iOS deployment target: 26.2 (as configured in the project)
- Swift: 5.0
- Simulator/device: iPhone 15 Pro (recommended) or any iOS 26.2-capable target

## Getting Started

### 1. Clone the Repository
```
 git clone <repo-url>
 cd <project-folder>
```

### 2. Open the Project
- Open `Calculator.xcodeproj` in Xcode.

### 3. Run the App
- Select a simulator (recommended: iPhone 15 Pro).
- Build & Run (⌘R).
- No special permissions are required; PDF export uses the share sheet.

### 4. Troubleshooting
- Build errors: try a clean build (⇧⌘K) and rebuild.
- Simulator issues: reset content and settings or reinstall the simulator.
- Core Data/file storage failures: ensure the simulator has writable storage and that the app has not been killed mid-write; delete the app from the simulator to reset the store.

## Architecture Overview
- MVVM with clean layering.
- UI: SwiftUI views only render state and bind to inputs.
- Presentation: ViewModels expose UI-ready state and forward intents.
- Domain: Use cases handle calculations, formatting, and decision logic.
- Data: Core Data repository for persistence; PDF renderer and file store for export.
- No business logic in Views.
- No business logic in ViewModels.

## Persistence
- Loan calculations are saved via Core Data.
- Stored in the app sandbox; entries are listed on the home screen.
- Tapping a saved entry opens its details view.

## Financial Logic Notes
- EMI formula: `M = P * r * (1+r)^n / ((1+r)^n - 1)` where `r` is monthly rate and `n` is months.
- Precision uses `Double`; display formatting is `NumberFormatter` to 2 decimals.
- 0% interest case uses simple division: `P / n`.
- Repayment schedule in UI is a short preview (first two installments).
- Rounding is display-only; calculations use unrounded `Double` values.

## Assumptions
- User input is in KES and uses decimal notation.
- Schedule preview only shows up to two future installments.
- Exported PDF mirrors the details screen content, not the full amortization table.

## Trade-offs
- Used `Double` for simplicity instead of decimal math for financial-grade precision.
- Repayment schedule is a preview rather than a full schedule to keep UI compact.
- PDF rendering uses a lightweight custom renderer to avoid heavy dependencies.

## Improvements
- Add full amortization schedule export and in-app viewing.
- Add unit tests for use cases and formatting services.
- Use decimal-based math for improved financial accuracy.
- Improve PDF styling to match the in-app theme exactly.

## Bonus (if applicable)
- Export feature: generates a PDF from the loan details screen and shares/saves it.

## Author
- fin

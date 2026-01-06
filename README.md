# ResetingView

A demonstration of a SwiftUI bug where `@State` variables unexpectedly reset when backgrounding and foregrounding an app with nested sheets in `NavigationStack`.

## The Issue

When using `NavigationStack` with nested `.sheet()` presentations, wrapping the first sheet's content in a `VStack`, `ZStack`, `HStack` causes `@State` variables in deeply nested views to reset their values when the app is backgrounded and then foregrounded.

### Reproduction Steps

1. Run the app and tap "With VStack"
2. Tap "Display Secondary State View"
3. Toggle "1. Make Circle" to ON (the rectangle becomes a circle)
4. Background the app (press Home button or swipe up)
5. Foreground the app again

**Expected Behavior:** The shape remains a circle

**Actual Behavior:** The shape resets to a rectangle (the `@State` variable resets to its initial value)

### Environment

- iOS 18.0+ (As of this writing 26.1 is current)
- SwiftUI
- Xcode project targeting iOS 18.0

## The Code Structure

The bug occurs with the following view hierarchy:

```swift
NavigationStack {
    VStack {  // ← This wrapper causes the issue
        FirstView()
            .sheet(isPresented: $isDisplayed) {
                SecondaryStateView()  // @State resets here on app foreground
            }
    }
}
```

The issue specifically affects:
- ContentView.swift:30-36 - The problematic "With VStack" implementation

## Workarounds

This project demonstrates two working solutions:

### Solution 1: Remove the VStack Wrapper

Don't wrap the first sheet's content in a `VStack`:

```swift
NavigationStack {
    FirstView()  // No VStack wrapper
        .sheet(isPresented: $isDisplayed) {
            SecondaryStateView()  // Works correctly
        }
}
```

See ContentView.swift:37-41 for the working implementation.

### Solution 2: Use NavigationView Instead

Use the deprecated `NavigationView` instead of `NavigationStack`:

```swift
NavigationView {  // ← Use NavigationView
    VStack {
        FirstView()
            .sheet(isPresented: $isDisplayed) {
                SecondaryStateView()  // Works correctly
            }
    }
}
```

Toggle "Use NavigationView" in the app to test this workaround.


### Video Examples

#### Not Working

https://github.com/user-attachments/assets/909ba0ef-f5a8-4213-b2fa-3883a1e6885c

#### Working
https://github.com/user-attachments/assets/179527dc-1400-4770-9a1e-deae70cc5b8f

https://github.com/user-attachments/assets/2fa2c549-9f98-46e8-a3fe-4631f694265e




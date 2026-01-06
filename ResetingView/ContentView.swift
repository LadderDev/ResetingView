//
//  ContentView.swift
//  ResetingView
//
//  Created by Andrew Hulsizer on 1/5/26.
//

import SwiftUI

struct ContentView: View {
    @State var displayWithVStack: Bool = false
    @State var displayWithoutVStack: Bool = false
    @State var useNavigationView: Bool = false
    
    var body: some View {
        TabView {
            Tab {
                VStack(spacing: 40) {
                    Spacer()
                    Button("With VStack") {
                        displayWithVStack = true
                    }
                    Button("No VStack") {
                        displayWithoutVStack = true
                    }
                    Spacer()
                    Toggle("Use NavigationView", isOn: $useNavigationView)
                }
                .padding(.horizontal)
                .sheet(isPresented: $displayWithVStack) {
                    wrappedNavigationView {
                        VStack {
                            FirstView(expectationToWork: useNavigationView ? true : false)
                        }
                    }
                }
                .sheet(isPresented: $displayWithoutVStack) {
                    wrappedNavigationView {
                        FirstView(expectationToWork: true)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func wrappedNavigationView<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        if useNavigationView {
            NavigationView {
                content()
            }
        } else {
            NavigationStack {
                content()
            }
        }
    }
}

public struct FirstView: View {
    
    @State var isDisplayed: Bool = false
    
    let expectationToWork: Bool
    
    public var body: some View {
        Button("Display Secondary State View") {
            isDisplayed = true
        }.sheet(isPresented: $isDisplayed) {
            SecondaryStateView(expectationToWork: expectationToWork)
        }
    }
}

struct SecondaryStateView: View {
    @State var isCircle: Bool = false
    @Namespace var namespace
    
    let expectationToWork: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Rectangle()
                .fill(expectationToWork ? .green : .red)
                .frame(width: 88, height: 88)
                .cornerRadius(isCircle ? 44 : 0)
                .animation(.bouncy, value: isCircle)
            
            VStack(alignment: .leading, spacing: 12) {
                Toggle("1. Make Circle", isOn: $isCircle)
                Text("2. Background and Foreground the App")
                Text(expectationToWork ? "3. Shape should maintain" : "3. Shape will reset")
            }
            
        }
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}

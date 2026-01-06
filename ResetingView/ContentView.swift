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
    var body: some View {
        TabView {
            Tab {
                VStack(spacing: 40) {
                    Button("With VStack (Doesn't Work)") {
                        displayWithVStack = true
                    }
                    Button("No VStack (Works)") {
                        displayWithoutVStack = true
                    }
                }
                .sheet(isPresented: $displayWithVStack) {
                    NavigationStack {
                        VStack {
                            HackView()
                        }
                    }
                }
                .sheet(isPresented: $displayWithoutVStack) {
                    NavigationStack {
                        HackView()
                    }
                }
            }
        }
    }
}

public struct HackView: View {
    
    @State var isDisplayed: Bool = false
    public var body: some View {
        Button("Quick") {
            isDisplayed = true
        }.sheet(isPresented: $isDisplayed) {
            EditRecipeView()
        }
    }
}

struct EditRecipeView: View {
    @State var clicked: Bool = false

    var body: some View {
        let _ = Self._printChanges()
        Color.black
            .onTapGesture {
                clicked = true
            }
            .overlay {
                if clicked {
                    Color.red
                }
            }
    }
}

#Preview {
    ContentView()
}

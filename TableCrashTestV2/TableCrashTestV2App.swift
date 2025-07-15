//
//  TableCrashTestV2App.swift
//  TableCrashTestV2
//
//  Created by Chris Jones on 15/07/2025.
//

import SwiftUI

@main
struct TableCrashTestV2App: App {
    @State var viewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: $viewModel)
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button(action: {
                    print("DELETE MENU")
                    viewModel.deleteSelected()
                }) {
                    Text("Delete")
                }
                .keyboardShortcut(.delete)
            }
        }
    }
}

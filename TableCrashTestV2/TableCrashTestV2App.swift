//
//  TableCrashTestV2App.swift
//  TableCrashTestV2
//
//  Created by Chris Jones on 15/07/2025.
//

/*
STEPS TO REPRODUCE CRASH:
 1. Run app
 2. Drag a file from Finder onto the app window. A row will appear
 3. Select the new row
 4. Hit cmd+delete, the row will be removed
 5. Drag a file from Finder onto the app window.
 6. The app just crashed
*/

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

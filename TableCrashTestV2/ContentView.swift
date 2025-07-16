//
//  ContentView.swift
//  TableCrashTestV2
//
//  Created by Chris Jones on 15/07/2025.
//

import SwiftUI

// We can rule out Node being @Observable as being relevant to the crash:
//  * Comment out the @Observable macro
//  * in ViewModel::deleteSelected() uncomment the withMutation wrapper
//  * in the .dropDestination() handler below, uncomment the withMutation wrapper
//  * Build&Run, the crash is still reproducible

@Observable
final class Node: Identifiable, Transferable {
    let id = UUID()
    var name: String = "UNKNOWN"
    var url: URL = URL(fileURLWithPath: "file:///UNKNOWN")
    var children: [Node]? = nil

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .data, shouldAttemptToOpenInPlace: true) { node in
            print("Node transferRepresentation:: Exporting \(node.url)")
            return SentTransferredFile(node.url)
        } importing: { receivedFile in
            let url = receivedFile.file
            let name = url.lastPathComponent
            let newNode = Node()
            newNode.name = name
            newNode.url = url
            print("Node transferRepresentation: Importing \(url)")
            return newNode
        }
    }
}

@Observable
final class ViewModel {
    var root: Node = Node()

    var selectedEntries = Set<Node.ID>()
    var sortOrder = [KeyPathComparator(\Node.name)]

    init() {
        print("ViewModel init:: Setting root.children to empty")
        root.children = []
    }

    func deleteSelected() {
        if !selectedEntries.isEmpty {
            // Uncomment the withMutation if you have removed @Observable from Node
//            self.withMutation(keyPath: \.root) {
                print("deleteSelected():: Deleting entries")
                root.children!.removeAll { selectedEntries.contains($0.id) }
//            }
        }
    }
}

struct ContentView: View {
    @Binding var viewModel: ViewModel

    @AppStorage("TableCustomisation") var columnCustomization: TableColumnCustomization<Node>

    var body: some View {
        let _ = Self._printChanges()

        Table(of: Node.self, selection: $viewModel.selectedEntries, sortOrder: $viewModel.sortOrder, columnCustomization: $columnCustomization) {
            TableColumn("ID", value: \Node.id.uuidString)
            TableColumn("Name", value: \Node.name)
            TableColumn("URL", value: \Node.url.absoluteString)
        } rows: {
            OutlineGroup(viewModel.root.children!, children: \.children) { node in
                TableRow(node)
                    .dropDestination(for: Node.self) { items in
                        // Don't actually need to implement this for the crash, but we would parent the dropped file into node.children
                        print(items)
                    }
            }
        }
        .dropDestination(for: Node.self) { items, _ in
            // Uncomment the withMutation if you have removed @Observable from Node
//            viewModel.withMutation(keyPath: \.root) {
                print("Table dropDestination: Adding \(items.count) dropped items")
                viewModel.root.children!.append(contentsOf: items)
//            }
            return true
        }
    }
}

//#Preview {
//    ContentView()
//}

//
//  ContentView.swift
//  TableCrashTestV2
//
//  Created by Chris Jones on 15/07/2025.
//

import SwiftUI

@Observable // If this is removed, the Table never updates when the nodes change
final class Node: Identifiable, Transferable {
    let id = UUID()
    var name: String = "UNKNOWN"
    var url: URL = URL(fileURLWithPath: "file:///UNKNOWN")
    var children: [Node]? = nil

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .data, shouldAttemptToOpenInPlace: true) { node in
            return SentTransferredFile(node.url)
        } importing: { receivedFile in
            let url = receivedFile.file
            let name = url.lastPathComponent
            let newNode = Node()
            newNode.name = name
            newNode.url = url
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
        root.children = []
    }

    func deleteSelected() {
        if !selectedEntries.isEmpty {
            root.children!.removeAll { selectedEntries.contains($0.id) }
        }
    }
}

struct ContentView: View {
    @Binding var viewModel: ViewModel

    @AppStorage("TableCustomisation") var columnCustomization: TableColumnCustomization<Node>

    var body: some View {
        Table(of: Node.self, selection: $viewModel.selectedEntries, sortOrder: $viewModel.sortOrder, columnCustomization: $columnCustomization) {
            TableColumn("ID", value: \Node.id.uuidString)
            TableColumn("Name", value: \Node.name)
            TableColumn("URL", value: \Node.url.absoluteString)
        } rows: {
            OutlineGroup(viewModel.root.children!, children: \.children) { node in
                TableRow(node)
                    .dropDestination(for: Node.self) { items in
                        print(items)
                    }
            }
        }
        .dropDestination(for: Node.self) { items, _ in
            viewModel.root.children!.append(contentsOf: items)
            return true
        }
    }
}

//#Preview {
//    ContentView()
//}

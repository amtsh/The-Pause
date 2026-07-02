//
//  ContentView.swift
//  The Pause
//
//  Created by Amit Shinde on 2026-07-02.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("The Pause")
                    .font(.headline)
                Spacer()
                Button(action: addItem) {
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderless)
                .help("Add Item")
            }
            .padding(.horizontal)
            .padding(.vertical, 10)

            Divider()

            if items.isEmpty {
                ContentUnavailableView("No Items", systemImage: "tray", description: Text("Add an item to get started."))
                    .frame(maxHeight: .infinity)
            } else {
                List {
                    ForEach(items) { item in
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                    .onDelete(perform: deleteItems)
                }
            }

            Divider()

            HStack {
                Spacer()
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut("q")
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
        .frame(width: 320, height: 400)
}

//
//  ContentView.swift
//  iExpense
//
//  Created by Kopácsi Barna Martin on 2025. 05. 13..
//
// Copyright © 2025 [Kopácsi Barna Martin]. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.
// You may not use this material for commercial purposes without obtaining permission from the author.
//

import SwiftUI


struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    
    @State private var expenses = Expenses()
    @State private var showingAddView = false
    
    var personalItems: [ExpenseItem] {
        var result = [ExpenseItem]()
        for item in expenses.items {
            if item.type == "Personal" {
                result.append(item)
            }
        }
        return result
    }
    
    var businessItems: [ExpenseItem] {
        var result = [ExpenseItem]()
        for item in expenses.items {
            if item.type == "Business" {
                result.append(item)
            }
        }
        return result
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    ForEach(personalItems) { item in
                        HStack {
                                Text(item.name)
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "HUF"))
                                .foregroundStyle(
                                    item.amount < 1000 ? .green :
                                    item.amount >= 1000 && item.amount < 10000 ? .orange : .red
                                    )
                        }
                    }
                    .onDelete(perform: removePersonal)
                }
                Section("Business") {
                    ForEach(businessItems) { item in
                        HStack {
                                Text(item.name)
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "HUF"))
                                .foregroundStyle(
                                    item.amount < 1000 ? .green :
                                    item.amount >= 1000 && item.amount < 10000 ? .orange : .red
                                    )
                        }
                    }
                    .onDelete(perform: removeBusiness)
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Expense", systemImage: "plus") {
                        showingAddView = true
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddView) {
            AddView(expenses: expenses)
        }
    }
    
    func removePersonal(at offsets: IndexSet) {
        for index in offsets {
            let itemToDelete = personalItems[index]
            if let actualIndex = expenses.items.firstIndex(where: { $0.id == itemToDelete.id }) {
                expenses.items.remove(at: actualIndex)
            }
        }
    }
    
    func removeBusiness(at offsets: IndexSet) {
        for index in offsets {
            let itemToDelete = businessItems[index]
            if let actualIndex = expenses.items.firstIndex(where: { $0.id == itemToDelete.id }) {
                expenses.items.remove(at: actualIndex)
            }
        }
    }
}

#Preview {
    ContentView()
}

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
import SwiftData

struct ContentView: View {
    @State private var showingAddView = false
    @State private var filter = "All"
    
    @Environment(\.modelContext) var modelContext
    
    @State private var sortOrder = [
        SortDescriptor(\ExpenseItem.name),
        SortDescriptor(\ExpenseItem.amount)
    ]
    
    var body: some View {
        NavigationStack {
            List {
                if filter == "All" || filter == "Personal" {
                    Section("Personal") {
                        ExpensesView(type: "Personal", sortOrder: sortOrder)
                    }
                }
                            
                if filter == "All" || filter == "Business" {
                    Section("Business") {
                        ExpensesView(type: "Business", sortOrder: sortOrder)
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort by", selection: $sortOrder) {
                            Text("Sort by name")
                                .tag([
                                SortDescriptor(\ExpenseItem.name),
                                SortDescriptor(\ExpenseItem.amount)
                            ])
                            Text("Sort by amount")
                                .tag([
                                SortDescriptor(\ExpenseItem.amount),
                                SortDescriptor(\ExpenseItem.name)
                            ])
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("All", systemImage: "line.3.horizontal.decrease.circle") {
                        Picker("Show", selection: $filter) {
                            Text("All")
                                .tag("All")
                            
                            Text("Personal")
                                .tag("Personal")
                            
                            Text("Business")
                                .tag("Business")
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddView = true
                    } label: {
                        Label("Add Expense", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddView()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ExpenseItem.self)
}

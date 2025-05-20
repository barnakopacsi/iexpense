//
//  ExpensesView.swift
//  iExpense
//
//  Created by Rozmann-ne Bujtor Beata on 2025. 05. 20..
//

import SwiftUI
import SwiftData

struct ExpensesView: View {
    var type: String
    var sortOrder: [SortDescriptor<ExpenseItem>]

    @Query private var items: [ExpenseItem]

    @Environment(\.modelContext) private var modelContext

    init(type: String, sortOrder: [SortDescriptor<ExpenseItem>]) {
        self.type = type
        self.sortOrder = sortOrder
        _items = Query(filter: #Predicate<ExpenseItem> { item in
            item.type == type
        }, sort: sortOrder)
    }

    var body: some View {
            ForEach(items) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "HUF"))
                        .foregroundStyle(
                            item.amount < 1000 ? .green :
                            item.amount < 10000 ? .orange : .red
                        )
                }
            }
            .onDelete(perform: deleteItems)
    }

    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = items[index]
            modelContext.delete(item)
        }
    }
}

#Preview {
    NavigationStack {
        VStack {
            ExpensesView(type: "Personal", sortOrder: [SortDescriptor(\ExpenseItem.name)])
            ExpensesView(type: "Business", sortOrder: [SortDescriptor(\ExpenseItem.amount, order: .reverse)])
        }
    }
    .modelContainer(for: ExpenseItem.self)
}


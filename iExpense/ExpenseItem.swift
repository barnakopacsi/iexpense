//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Rozmann-ne Bujtor Beata on 2025. 05. 20..
//

import Foundation
import SwiftData

@Model
class ExpenseItem {
    var name: String
    var type: String
    var amount: Double
    
    init(name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }
}

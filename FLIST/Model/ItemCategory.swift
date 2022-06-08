//
//  ItemCategory.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/5/17.
//

import Foundation
import SwiftUI

enum ItemCategory: Int, CaseIterable {
    
    case vegetables = 0
    case fruits
    case meat
    case fish
    case bread
    case beverage
    case diary
    case snack
    case others
    
    
    var categoryString: String {
        switch self {
        case .vegetables:
            return "Vegetables"
        case .fruits:
            return "Fruits"
        case .others:
            return "Others"
        case .meat:
            return "Meat"
        case .fish:
            return "Fish"
        case .snack:
            return "Snack"
        case .bread:
            return "Bread"
        case .beverage:
            return "Beverage"
        case .diary:
            return "Diary"
        }
    }
    
    var icon: String {
        switch self {
        case .vegetables:
            return "🥦"
        case .fruits:
            return "🍎"
        case .others:
            return "🍴"
        case .meat:
            return "🍖"
        case .fish:
            return "🐟"
        case .bread:
            return "🍞"
        case .beverage:
            return "🧃"
        case .diary:
            return "🥛"
        case .snack:
            return "🍪"
        }
    }
}

extension ItemCategory: Identifiable {
    var id: Int { rawValue }
}

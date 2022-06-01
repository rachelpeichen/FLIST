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
            return "veg"
        case .fruits:
            return "fruit"
        case .others:
            return "cart"
        case .meat:
            return "heart.circle.fill"
        case .fish:
            return "heart.circle.fill"
        case .bread:
            return "heart.circle.fill"
        case .beverage:
            return "heart.circle.fill"
        case .diary:
            return "heart.circle.fill"
        case .snack:
            return "heart.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .vegetables:
            return .green
        case .fruits:
            return .pink
        case .others:
            return .blue
        case .meat:
            return .brown
        case .fish:
            return .gray
        case .bread:
            return .gray
        case .beverage:
            return .gray
        case .diary:
            return .gray
        case .snack:
            return .gray
        }
    }
}

extension ItemCategory: Identifiable {
    var id: Int { rawValue }
}

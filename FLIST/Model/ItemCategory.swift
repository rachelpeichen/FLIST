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
    case grains
    case canned
    case freezer
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
        case .meat:
            return "Meat"
        case .fish:
            return "Fish"
        case .grains:
            return "Grains"
        case .canned:
            return "Canned Food"
        case .freezer:
            return "Frozen Food"
        case .beverage:
            return "Beverage"
        case .diary:
            return "Diary"
        case .snack:
            return "Snack"
        case .others:
            return "Others"
        }
    }
    
    var icon: String {
        switch self {
        case .vegetables:
            return "🥦"
        case .fruits:
            return "🍎"
        case .meat:
            return "🍖"
        case .fish:
            return "🐟"
        case .grains:
            return "🍞"
        case .canned:
            return "🥫"
        case .freezer:
            return "❄️"
        case .beverage:
            return "🧃"
        case .diary:
            return "🧀"
        case .snack:
            return "🍪"
        case .others:
            return "🦄"
        }
    }
}

extension ItemCategory: Identifiable {
    var id: Int { rawValue }
}

//
//  SortModel.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/6/7.
//

import Foundation

enum SortType: String, CaseIterable {
    case expiredDate
    case quantity
}

extension SortType: Identifiable {
    var id: String { rawValue }
}

enum SortOrder: String, CaseIterable {
    case ascending
    case descending
}

extension SortOrder: Identifiable {
    var id: String { rawValue }
}

struct ItemSort {
    var sortType: SortType
    var sortOrder: SortOrder
    
    var isAscending: Bool {
        sortOrder == .ascending ? true : false
    }
    
    var sortDescriptor: NSSortDescriptor {
        switch sortType {
        case .expiredDate:
            return NSSortDescriptor(keyPath: \ItemModel.expiredDate, ascending: isAscending)
        case .quantity:
            return NSSortDescriptor(keyPath: \ItemModel.quantity, ascending: isAscending)
        }
    }
}

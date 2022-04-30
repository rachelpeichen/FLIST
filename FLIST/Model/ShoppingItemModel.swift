//
//  ShoppingItemModel.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/8.
//

import Foundation
import CoreData

enum Priority: Int {
    case low = 0
    case normal = 1
    case high = 2
}

public class ShoppingItemModel: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var priorityNum: Int32
    @NSManaged public var isComplete: Bool
}

extension ShoppingItemModel: Identifiable {
    var priority: Priority {
        get {
            return Priority(rawValue: Int(priorityNum)) ?? .normal
        }

        set {
            self.priorityNum = Int32(newValue.rawValue)
        }
    }
}

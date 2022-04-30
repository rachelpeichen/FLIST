//
//  ItemModel.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/27.
//

import Foundation
import CoreData

enum ItemCategory: Int {
    case fridge = 0
    case freezer = 1
    case others = 2
}

public class ItemModel: NSManagedObject {
    @NSManaged public var typeNum: Int32
    @NSManaged public var itemId: UUID
    @NSManaged public var name: String
    @NSManaged public var quantity: Double
    @NSManaged public var purchaseDate: Date?
    @NSManaged public var expiredDate: Date?
    @NSManaged public var memo: String?
}

extension ItemModel: Identifiable {
    var type: ItemCategory {
        get {
            return ItemCategory(rawValue: Int(typeNum)) ?? .fridge
        }
        
        set {
            self.typeNum = Int32(newValue.rawValue)
        }
    }
}

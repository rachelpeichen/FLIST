//
//  ItemModel.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/27.
//

import Foundation
import CoreData

public class ItemModel: NSManagedObject {
    @NSManaged public var categoryNum: Int32
    @NSManaged public var itemId: UUID
    @NSManaged public var name: String
    @NSManaged public var quantity: Double
    @NSManaged public var purchaseDate: Date?
    @NSManaged public var expiredDate: Date?
    @NSManaged public var memo: String?
}

extension ItemModel: Identifiable {
    
    var category: ItemCategory {
        get {
            return ItemCategory(rawValue: Int(categoryNum)) ?? .vegetables
        }
        
        set {
            self.categoryNum = Int32(newValue.rawValue)
        }
    }
}

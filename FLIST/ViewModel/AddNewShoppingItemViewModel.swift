//
//  AddNewShoppingItemViewModel.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/30.
//

import Foundation
import Combine

class AddNewShoppingItemViewModel: ObservableObject {
    
    @Published var priority = Priority.normal
    @Published var name = ""
    @Published var isComplete = false
    
    init(shoppingItemModel: ShoppingItemModel?) {
        self.priority = shoppingItemModel?.priority ?? .normal
        self.name = shoppingItemModel?.name ?? ""
        self.isComplete = shoppingItemModel?.isComplete ?? false
    }
}

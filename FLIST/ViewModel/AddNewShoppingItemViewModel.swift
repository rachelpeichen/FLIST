//
//  AddNewShoppingItemViewModel.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/30.
//

import Foundation
import Combine

class AddNewShoppingItemViewModel: ObservableObject {
    // Input
    @Published var type = ItemCategory.fridge
    @Published var name = ""
    @Published var quantity = ""
    @Published var purchaseDate: Date?
    @Published var expiredDate: Date?
    @Published var memo = ""
}

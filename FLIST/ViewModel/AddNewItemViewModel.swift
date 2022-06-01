//
//  AddNewItemViewModel.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/27.
//

import Foundation
import Combine

class AddNewItemViewModel: ObservableObject {
    
    // Input
    @Published var category = ItemCategory.others
    @Published var name = ""
    @Published var quantity = ""
    @Published var purchaseDate: Date?
    @Published var expiredDate: Date?
    @Published var memo = ""
    
    // Output
    @Published var isNameValid = false
    @Published var isQuantityValid = false
    @Published var isInputValid = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(itemModel: ItemModel?) {
        
        self.category = itemModel?.category ?? .vegetables
        self.name = itemModel?.name ?? ""
        self.quantity = "\(itemModel?.quantity ?? 1.0)"
        self.purchaseDate = itemModel?.purchaseDate
        self.expiredDate = itemModel?.expiredDate
        self.memo = itemModel?.memo ?? ""
        
        $name
            .receive(on: RunLoop.main)
            .map { name in
                return name.count > 0
            }
            .assign(to: \.isNameValid, on: self)
            .store(in: &cancellableSet)
        
        $quantity
            .receive(on: RunLoop.main)
            .map { qty in
                guard let validQty = Double(qty) else { return false }
                return validQty > 0
            }
            .assign(to: \.isQuantityValid, on: self)
            .store(in: &cancellableSet)
        
        Publishers.CombineLatest($isNameValid, $isQuantityValid)
            .receive(on: RunLoop.main)
            .map { (isNameValid, isQuantityValid) in
                return isNameValid && isQuantityValid
            }
            .assign(to: \.isInputValid, on: self)
            .store(in: &cancellableSet)
    }
}

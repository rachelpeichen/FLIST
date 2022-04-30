//
//  ShoppingListRowView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/7.
//

import SwiftUI

struct ShoppingListRow: View {
    
    // MARK: - Parameters
    @ObservedObject var shoppingItem: ShoppingItemModel
    
    var body: some View {
        Toggle(isOn: self.$shoppingItem.isComplete) {
            HStack {
                Text(self.shoppingItem.name)
                    .strikethrough(self.shoppingItem.isComplete, color: .black)
                    
                Spacer()
                
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(self.setColor(for: self.shoppingItem.priority))
                
            }
        }.toggleStyle(CheckboxStyle())
//        // 加入以下程式碼
//            .onChange(of: todoItem) { newValue in
//                if self.context.hasChanges {
//                    try? self.context.save()
//                }
//            }
    }
    
    private func setColor(for priority: Priority) -> Color {
        switch priority {
        case .high: return .red
        case .normal: return .orange
        case .low: return .green
        }
    }
}

//struct ShoppingListRowView_Previews: PreviewProvider {
//    static var previews: some View {
////        let previewItem = ShoppingItemModel(context: <#T##NSManagedObjectContext#>)
////        ShoppingListRow(shoppingItem: previewItem)
//    }
//}

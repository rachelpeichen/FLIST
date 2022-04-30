//
//  FridgeView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/7.
//

import SwiftUI
import CoreData

struct FridgeView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
        entity: ItemModel.entity(),
        sortDescriptors: [ NSSortDescriptor(keyPath: \ItemModel.expiredDate, ascending: false)])
    var items: FetchedResults<ItemModel>
    
    private var itemsDataForView: [ItemModel] {
        return items.filter { $0.type == .fridge }
    }
    
    var body: some View {
        VStack {
            
            List {
                ForEach(itemsDataForView) { item in
//                    ItemCellView(item: item)
                }
                
            }
        }
    }
    
    private func deleteItem(indexSet: IndexSet) {
        for index in indexSet {
            let itemToBeDeleted = items[index]
            context.delete(itemToBeDeleted)
        }
        
        DispatchQueue.main.async {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Preview

struct Tabs1View_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = PersistenceController.shared.container.viewContext
        let previewItem = ItemModel(context: context)
        previewItem.itemId = UUID()
        previewItem.name = "Apples"
        previewItem.quantity = 5.0
        previewItem.purchaseDate = .today
        
        
        return Group {
            FridgeView()
            
//            ItemCellView(item: previewItem).previewLayout(.sizeThatFits)
        }
    }
}

// MARK: - Extracted Views

//struct ItemCellView: View {
//
//    @ObservedObject var item: ItemModel
//
//    var body: some View {
//
//        HStack(spacing: 20) {
//
//            if item.isFault {
//                EmptyView()
//
//            }  else {
//                Image(systemName: "bag.circle.fill")
//                    .font(.title)
//                    .foregroundColor(.orange)
//
//                VStack(alignment: .leading) {
//                    Text(item.name)
//                        .font(.system(.body, design: .rounded))
//                    Text(item.purchaseDate?.asString() ?? "")
//                        .font(.system(.caption, design: .rounded))
//                        .foregroundColor(.gray)
//                }
//
//                Spacer()
//
//                Text("x \(item.quantity)")
//                    .font(.system(.headline, design: .rounded))
//            }
//        }
//        .padding()
//    }
//}

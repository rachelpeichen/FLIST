 //
//  ItemListView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/6/1.
//

import SwiftUI
import CoreData

struct ItemListView: View {
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    @FetchRequest(
        entity: ItemModel.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ItemModel.expiredDate, ascending: false)]
    )
    
    private var itemFetchResult: FetchedResults<ItemModel>
    @State var itemToEdit: ItemModel?
    
    // MARK: - Initializer
    init(predicate: NSPredicate?, sortDescriptor: NSSortDescriptor) {
        let fetchRequest = NSFetchRequest<ItemModel>(entityName: ItemModel.entity().name ?? "ItemModel")
        fetchRequest.sortDescriptors = [sortDescriptor]

        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        // MARK: - 這樣寫死是可以的所以應該是 ItemModel Predicate 那邊出問題
//        } else {
//            fetchRequest.predicate = NSPredicate(format: "categoryNum == %@", "\(1)")
//        }

        _itemFetchResult = FetchRequest(fetchRequest: fetchRequest)
    }
    
    var body: some View {
        List {
            ForEach(itemFetchResult) { (item: ItemModel) in
                Button {
                    self.itemToEdit = item
                } label: {
                    HStack(spacing: 20) {
                        
                        Image(item.category.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .padding(.all, 8)
                            .foregroundColor(item.category.color)
                            .background(item.category.color.opacity(0.1))
                            .cornerRadius(18)
                        
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.primary)
                            Text("Expired Date: \(item.expiredDate?.asString() ?? "No Record")")
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Text("x \(NumberFormatter.asString(from: item.quantity))")
                            .font(.system(.headline, design: .rounded))
                            .foregroundColor(.primary)
                    }
                }
                .frame(height: 45)
                .sheet(item: $itemToEdit, onDismiss: {
                    self.itemToEdit = nil
                }) { (item: ItemModel) in
                    AddNewItemView(editItem: item, showDeleteButton: true)
                }
            }
            .onDelete(perform: deleteItem(indexSet:))
        }
    }
    
    private func deleteItem(indexSet: IndexSet) {
        for index in indexSet {
            let itemToDelete = itemFetchResult[index]
            context.delete(itemToDelete)
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

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        return ItemListView(predicate: nil, sortDescriptor: NSSortDescriptor(keyPath: \ItemModel.expiredDate, ascending: false)).environment(\.managedObjectContext, PersistenceController.itemPreview.container.viewContext)
    }
}

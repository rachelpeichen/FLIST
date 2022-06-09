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
        sortDescriptors: [NSSortDescriptor(keyPath: \ItemModel.expiredDate, ascending: true)]
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

        _itemFetchResult = FetchRequest(fetchRequest: fetchRequest)
    }
    
    var body: some View {
        List {
            ForEach(itemFetchResult) { (item: ItemModel) in
                Button {
                    self.itemToEdit = item
                } label: {
                    HStack(spacing: 20) {
                        
                        Text(item.category.icon)
                        
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.primary)
                            
                            HStack {
                                Text(LocalizedStringKey("Expiration Date"))
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundColor(.gray)
                                Text(item.expiredDate?.asString() ?? "No Record")
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                        
                        Text("x \(NumberFormatter.asString(from: item.quantity))")
                            .font(.system(.headline, design: .rounded))
                            .foregroundColor(.primary)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .frame(height: 45)
                .sheet(item: $itemToEdit, onDismiss: {
                    self.itemToEdit = nil
                }) { (item: ItemModel) in
                    AddNewItemView(editItem: item, showDeleteButton: true)
                }
            }
            .onDelete(perform: deleteItem(indexSet:))
        }
        .overlay(alignment: .center) {
            // If there is no data, show an empty view
            if itemFetchResult.count == 0 {
                NoDataView()
            }
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
        let sortDescriptor = ItemSort(sortType: .expiredDate, sortOrder: .descending).sortDescriptor
        return ItemListView(predicate: nil, sortDescriptor: sortDescriptor).environment(\.managedObjectContext, PersistenceController.itemPreview.container.viewContext)
    }
}

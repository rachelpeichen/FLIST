//
//  MainView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/7.
//

import SwiftUI
import CoreData

enum ItemStoreDisplayType {
    case all
    case fridge
    case freezer
    case others
}

enum ItemCategory {
    case veg
    case fruit
}

struct MainView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
        entity: ItemModel.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ItemModel.expiredDate, ascending: false)]
    )
    
    var items: FetchedResults<ItemModel>
    
    private var itemDataForView: [ItemModel] {
        switch storeDisplayType {
        case .all:
            return items
                .sorted { $0.expiredDate ?? .tenYear < $1.expiredDate ?? .tenYear }
        case .fridge:
            return items
                .filter { $0.type == .fridge }
                .sorted { $0.expiredDate ?? .tenYear < $1.expiredDate ?? .tenYear }
        case .freezer:
            return items
                .filter { $0.type == .freezer }
                .sorted { $0.expiredDate ?? .tenYear < $1.expiredDate ?? .tenYear }
        case .others:
            return items
                .filter { $0.type == .others }
                .sorted { $0.expiredDate ?? .tenYear < $1.expiredDate ?? .tenYear }
        }
    }
    
    @State private var storeDisplayType: ItemStoreDisplayType = .all
    @State private var selectedItem: ItemModel?
    @State private var showingAddItemView = false
    @State private var showingEditItemView = false
    // TODO: 搜尋功能
    @State var searchQuery = ""
    
    var body: some View {
        VStack {
            
            HStack {
                Text("My Storage")
                    .font(.system(.title, design: .rounded))
                    .foregroundColor(Color.orange)
                    .bold()
                
                Spacer()
                
                Button {
                    showingAddItemView.toggle()
                } label : {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.orange)
                        .font(.title)
                }
                .sheet(isPresented: $showingAddItemView) {
                    AddNewItemView(newItem: nil)
                }
            }
            .padding()
            
            SearchBar(text: $searchQuery)
                .padding(.bottom)
            
            DisplayTypeBar(displayType: $storeDisplayType)
            
            // 蔬菜啥的分類
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(1...10, id: \.self) { _ in
                        CategoryCellView(name: "Vegetables")
                    }
                }
            }
         
            ScrollView {
                ForEach(itemDataForView) { item in
                    ItemCellView(item: item)
                        .onTapGesture {
                            self.showingEditItemView = true
                            self.selectedItem = item
                        }
                }
                .sheet(isPresented: self.$showingEditItemView) {
                    AddNewItemView(newItem: self.selectedItem, showDeleteButton: true)
                        .environment(\.managedObjectContext, self.context)
                }
            }
        }
    }
}

// MARK: - Preview

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let previewItem = ItemModel(context: context)
        previewItem.itemId = UUID()
        previewItem.name = "Apples"
        previewItem.quantity = 5.0
        previewItem.purchaseDate = .today
        previewItem.expiredDate = .tomorrow
        
        return Group {
            MainView().environment(\.managedObjectContext, PersistenceController.itemPreview.container.viewContext)
            DisplayTypeBar(displayType: .constant(.all)).previewLayout(.sizeThatFits)
            ItemCellView(item: previewItem).previewLayout(.sizeThatFits)
        }
    }
}

// MARK: - Extracted Views

struct DisplayTypeBar: View {
    
    @Binding var displayType: ItemStoreDisplayType
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Group {
                    VStack {
                        Text("All")
                            .minimumScaleFactor(0.8)
                            .foregroundColor(displayType == .all ? .orange : .gray)
                            .onTapGesture {
                                self.displayType = .all
                            }
                        
                        Rectangle()
                            .fill(displayType == .all ? .orange : .white)
                            .frame(height: 1)
                    }
                    
                    VStack {
                        Text("Fridge")
                            .minimumScaleFactor(0.8)
                            .foregroundColor(displayType == .fridge ? .orange : .gray)
                            .onTapGesture {
                                self.displayType = .fridge
                        }
                        
                        Rectangle().fill(displayType == .fridge ? .orange : .white).frame(height: 1)
                    }
                    
                    VStack {
                        Text("Freezer")
                            .minimumScaleFactor(0.8)
                            .foregroundColor(displayType == .freezer ? .orange : .gray)
                            .onTapGesture {
                                self.displayType = .freezer
                        }
                        
                        Rectangle().fill(displayType == .freezer ? .orange : .white).frame(height: 1)
                    }
                    
                    VStack {
                        Text("Others")
                            .minimumScaleFactor(0.8)
                            .foregroundColor(displayType == .others ? .orange : .gray)
                            .onTapGesture {
                                self.displayType = .others
                        }
                        
                        Rectangle().fill(displayType == .others ? .orange : .white).frame(height: 1)
                    }
                }
                .lineLimit(1)
                .font(.system(.subheadline, design: .rounded))
                
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            .frame(maxWidth: .infinity)
        }
    }
}

struct ItemCellView: View {
    
    @ObservedObject var item: ItemModel
    
    var body: some View {
        
        HStack(spacing: 20) {
            
            if item.isFault {
                EmptyView()
                
            }  else {
                Image(systemName: "bag.circle.fill")
                    .font(.title)
                    .foregroundColor(.orange)
                
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.system(.body, design: .rounded))
                    Text("Expired Date: \(item.expiredDate?.asString() ?? "No Record")")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text("x \(NumberFormatter.asString(from: item.quantity))")
                    .font(.system(.headline, design: .rounded))
            }
        }
        .padding()
    }
}


struct CategoryCellView: View {
    let name: String
    var body: some View {
        VStack {
            Text(name)
                .font(.system(.subheadline, design: .rounded))
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                .background(Color.mint)
                .cornerRadius(20)
                .frame(height: 40)
                .onTapGesture {
                    
                }
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
    }
}

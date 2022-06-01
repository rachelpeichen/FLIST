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
    case vegs
    case fruits
    case others
}

struct MainView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
        entity: ItemModel.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ItemModel.expiredDate, ascending: false)]
    )
    
    //@State var selectedCategories: Set<ItemCategory> = Set()
    var items: FetchedResults<ItemModel>
    
    private var itemDataForView: [ItemModel] {
        switch storeDisplayType {
        case .all:
            return items
                .sorted { $0.expiredDate ?? .tenYear < $1.expiredDate ?? .tenYear }
        case .vegs:
            return items
                .filter { $0.category == .vegetables }
                .sorted { $0.expiredDate ?? .tenYear < $1.expiredDate ?? .tenYear }
        case .fruits:
            return items
                .filter { $0.category == .fruits }
                .sorted { $0.expiredDate ?? .tenYear < $1.expiredDate ?? .tenYear }
        case .others:
            return items
                .filter { $0.category == .others }
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
            
            // TODO: - 蔬菜啥的分類 抄expense tracker 那個看看？？？
            //ItemCategoryFilterView(selectedCategories: <#T##Binding<Set<ItemCategory>>#>)

         
            ScrollView {
                ForEach(itemDataForView) { item in
                    ItemCellView(category: item.category, item: item)
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
            ItemCellView(category: .fruits, item: previewItem).previewLayout(.sizeThatFits)
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
                        Text("Vegs")
                            .minimumScaleFactor(0.8)
                            .foregroundColor(displayType == .vegs ? .orange : .gray)
                            .onTapGesture {
                                self.displayType = .vegs
                        }
                        
                        Rectangle().fill(displayType == .vegs ? .orange : .white).frame(height: 1)
                    }
                    
                    VStack {
                        Text("Fruits")
                            .minimumScaleFactor(0.8)
                            .foregroundColor(displayType == .fruits ? .orange : .gray)
                            .onTapGesture {
                                self.displayType = .fruits
                        }
                        
                        Rectangle().fill(displayType == .fruits ? .orange : .white).frame(height: 1)
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
    
    let category: ItemCategory
    
    @ObservedObject var item: ItemModel
    
    var body: some View {
        
        HStack(spacing: 20) {
            
            if item.isFault {
                EmptyView()
                
            }  else {
                Image(category.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .padding(.all, 8)
                    .foregroundColor(category.color)
                    .background(category.color.opacity(0.1))
                    .cornerRadius(18)
                
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

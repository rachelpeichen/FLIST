//
//  MainView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/7.
//

import SwiftUI
import CoreData

enum ItemDisplayType {
    case all
    case fridge
    case freezer
    case others
}

struct MainView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
        entity: ItemModel.entity(),
        sortDescriptors: [ NSSortDescriptor(keyPath: \ItemModel.expiredDate, ascending: false)])
    var items: FetchedResults<ItemModel>
    
    private var itemDataForView: [ItemModel] {
        switch displayType {
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
    
    @State private var displayType: ItemDisplayType = .all
    @State private var selectedItem: ItemModel?
    @State private var showingAddItemPage = false
    @State private var showingEditItemPage = false
    //    @State private var selectedTab: Int = 0
    @State var searchQuery = ""
    
    //    let tabs: [Tab] = [.init(title: "Fridge"),
    //                       .init(title: "Freezer"),
    //                       .init(title: "Others")]
    
    var body: some View {
        VStack {
            
            HStack {
                Text("My Storage")
                    .font(.system(.title, design: .rounded))
                    .foregroundColor(Color.orange)
                    .bold()
                
                Spacer()
                
                Button {
                    showingAddItemPage.toggle()
                } label : {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.orange)
                        .font(.title)
                }
                .sheet(isPresented: $showingAddItemPage) {
                    AddNewItemView(newItem: nil)
                }
            }
            .padding()
            
            SearchBar(text: $searchQuery)
                .padding(.bottom)
            
            DisplayTypeBar(displayType: $displayType)
            
            //            ScrollView(showsIndicators: false) {
            
            ScrollView {
                ForEach(itemDataForView) { item in
                    ItemCellView(item: item)
                        .onTapGesture {
                            self.showingEditItemPage = true
                            self.selectedItem = item
                        }
                }
                .sheet(isPresented: self.$showingEditItemPage) {
                    AddNewItemView(newItem: self.selectedItem, showDeleteButton: true)
                        .environment(\.managedObjectContext, self.context)
                }
            }
            
            //            }
            
            // 好像不需要這樣 可以把 Tabs View 拆掉
            //                TabsView(tabs:  tabs, geoWidth: geo.size.width, selectedTab: $selectedTab)
            //
            //                TabView(selection: $selectedTab) {
            //                    FridgeView().tag(0)
            //                    FreezerView().tag(1)
            //                    OthersView().tag(2)
            //                }
            //                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
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
            MainView().environment(\.managedObjectContext, context)
            DisplayTypeBar(displayType: .constant(.all)).previewLayout(.sizeThatFits)
            ItemCellView(item: previewItem).previewLayout(.sizeThatFits)
        }
    }
}

// MARK: - Extracted Views

struct DisplayTypeBar: View {
    
    @Binding var displayType: ItemDisplayType
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Group {
                    Text("All")
                        .padding(5)
                        .padding(.horizontal, 15)
                        .background(displayType == .all ? .orange : .gray)
                        .onTapGesture {
                            self.displayType = .all
                        }
                    
                    Text("Fridge")
                        .padding(5)
                        .padding(.horizontal, 15)
                        .background(displayType == .fridge ? .orange : .gray)
                        .onTapGesture {
                            self.displayType = .fridge
                        }
                    
                    Text("Freezer")
                        .padding(5)
                        .padding(.horizontal, 15)
                        .background(displayType == .freezer ? .orange : .gray)
                        .onTapGesture {
                            self.displayType = .freezer
                        }
                    
                    Text("Others")
                        .padding(5)
                        .padding(.horizontal, 15)
                        .background(displayType == .others ? .orange : .gray)
                        .onTapGesture {
                            self.displayType = .others
                        }
                }
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.white)
                .cornerRadius(15)
            }
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

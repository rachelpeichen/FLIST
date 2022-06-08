//
//  MainView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/7.
//

import SwiftUI
import CoreData

struct MainView: View {
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    @EnvironmentObject var userSetting: UserSetting
    
    @State var showingAddItemView: Bool = false
    
    @State var searchText: String = ""
    
    @State var selectedCategories: Set<ItemCategory> = Set()
    @State var selectedItem: ItemModel?
    
    @State var sortType: SortType = SortType.expiredDate
    @State var sortOrder: SortOrder = SortOrder.descending

    var body: some View {
        VStack {
            // Header View
            HStack {
                Text("Grocery Inventory")
                    .font(.system(.title, design: .rounded))
                    .foregroundColor(Color(userSetting.selectedTheme.primaryColor))
                    .bold()
                    .environment(\.locale, .init(identifier: userSetting.selectedLanguage.rawValue))
                
                Spacer()
                
                Button {
                    showingAddItemView.toggle()
                } label : {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color(userSetting.selectedTheme.primaryColor))
                        .font(.title)
                }
                .sheet(isPresented: $showingAddItemView) {
                    AddNewItemView()
                }
            }
            .padding()
            
            // Search
            SearchBar(text: $searchText)
                .padding(.bottom)
            
            // Filter
            ItemCategoryFilterView(selectedCategories: $selectedCategories)
            
            // Sort Selector
            SortSelectorView(sortType: $sortType, sortOrder: $sortOrder)
            
            // Item List View
            ItemListView(predicate: ItemModel.predicate(with: Array(selectedCategories), searchText: searchText), sortDescriptor: ItemSort(sortType: sortType, sortOrder: sortOrder).sortDescriptor)
        }
    }
}

// MARK: - Preview

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(UserSetting())
    }
}

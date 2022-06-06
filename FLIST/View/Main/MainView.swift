//
//  MainView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/7.
//

import SwiftUI
import CoreData

struct MainView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @State var selectedCategories: Set<ItemCategory> = Set()
    @State private var selectedItem: ItemModel?
    @State private var showingAddItemView = false
    @State var searchText: String = ""
    
    var body: some View {
        VStack {
            // Header View
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
            
            // Search
            SearchBar(text: $searchText)
                .padding(.bottom)
            Divider()
            
            // TODO: 現在不會 crash 但沒法分類
            // Filter
            ItemCategoryFilterView(selectedCategories: $selectedCategories)
            Divider()
            
            // Item List View
            ItemListView(predicate: ItemModel.predicate(with: Array(selectedCategories), searchText: searchText), sortDescriptor: NSSortDescriptor(keyPath: \ItemModel.expiredDate, ascending: false))
        }
    }
}

// MARK: - Preview

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

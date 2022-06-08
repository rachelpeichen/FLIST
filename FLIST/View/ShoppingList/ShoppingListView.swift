//
//  ShoppingListView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/7.
//

import SwiftUI
import CoreData

struct ShoppingListView: View {
    
    @EnvironmentObject var dataSource: UserSetting
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
        entity: ShoppingItemModel.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingItemModel.priorityNum, ascending: false)]
    )
    
    var shoppingItemsFetchedResult: FetchedResults<ShoppingItemModel>
    
    @State private var showingAddShoppingItemView = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Shopping List")
                        .font(.system(.title, design: .rounded))
                        .foregroundColor(Color(dataSource.selectedTheme.primaryColor))
                        .bold()
                    
                    Spacer()
                    
                    Button {
                        showingAddShoppingItemView.toggle()
                    } label : {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color(dataSource.selectedTheme.primaryColor))
                            .font(.title)
                    }
                }
                .padding()
                
                List {
                    ForEach(shoppingItemsFetchedResult) { shoppingItem in
                        ShoppingListCellView(shoppingItem: shoppingItem)
                    }
                    .onDelete(perform: deleteTask(indexSet:))
                }
            }
            
            // If there is no data, show an empty view
            if shoppingItemsFetchedResult.count == 0 {
                NoDataView()
            }
            
            if showingAddShoppingItemView {
                BackgroundView(bgColor: .black)
                    .opacity(0.6)
                    .onTapGesture {
                        self.showingAddShoppingItemView.toggle()
                    }
                
                AddNewShoppingItemView(isShowing: $showingAddShoppingItemView, newShoppingItem: nil)
            }
        }
    }
    
    private func deleteTask(indexSet: IndexSet) {
        for index in indexSet {
            let itemToDelete = shoppingItemsFetchedResult[index]
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

// MARK: - Previews
struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView().environment(\.managedObjectContext, PersistenceController.shoppingItemPreview.container.viewContext).environmentObject(UserSetting())
    }
}

// MARK: - Extracted Views
struct NoDataView: View {
    var body: some View {
        Image("empty_package")
            .resizable()
            .frame(width: 100, height: 100)
    }
}

struct ShoppingListCellView: View {
    
    @Environment(\.managedObjectContext) var context
    @ObservedObject var shoppingItem: ShoppingItemModel
    
    var body: some View {
        
        Toggle(isOn: self.$shoppingItem.isComplete) {
            HStack {
                Text(self.shoppingItem.name)
                    .foregroundColor(.primary)
                    .strikethrough(self.shoppingItem.isComplete, color: .primary)
                
                Spacer()
                
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(self.setColor(for: self.shoppingItem.priority))
                
            }
            .frame(height: 45)
        }
        .toggleStyle(CheckboxStyle())
            .onChange(of: shoppingItem) { newValue in
                if self.context.hasChanges {
                    try? self.context.save()
                }
            }
    }
    
    private func setColor(for priority: Priority) -> Color {
        switch priority {
        case .high: return Color("HighPriorityColor")
        case .normal: return Color("MediumPriorityColor")
        case .low: return Color("LowPriorityColor")
        }
    }
}


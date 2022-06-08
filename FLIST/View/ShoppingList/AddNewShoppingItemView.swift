//
//  NewShoppingItemView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/8.
//

import SwiftUI

struct AddNewShoppingItemView: View {
    
    @EnvironmentObject var dataSource: UserSetting
    
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject private var addNewShoppingItemViewModel: AddNewShoppingItemViewModel
    
    @Binding var isShowing: Bool
    var newShoppingItem: ShoppingItemModel?
    
    init(isShowing: Binding<Bool>, newShoppingItem: ShoppingItemModel? = nil) {
        self._isShowing = isShowing
        self.newShoppingItem = newShoppingItem
        self.addNewShoppingItemViewModel = AddNewShoppingItemViewModel(shoppingItemModel: newShoppingItem)
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                
                // Header Bar
                HStack {
                    Text("Add a new shopping item")
                        .font(.system(.title, design: .rounded))
                        .bold()
                        .foregroundColor(Color(dataSource.selectedTheme.primaryColor))
                    
                    Spacer()
                    
                    Button {
                        isShowing = false
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(Color(dataSource.selectedTheme.primaryColor))
                            .font(.title)
                    }
                }
                .padding(.bottom)
                
                // Name TextField
                FormTextField(name: "Name", placeHolder: "Enter new item name", value: $addNewShoppingItemViewModel.name)
                
                // Priority Selection
                Text("Priority")
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top)
                
                HStack {
                    
                    // High Priority Button
                    Button {
                        self.addNewShoppingItemViewModel.priority = .high
                    } label: {
                        Text("High")
                            .lineLimit(1)
                            .font(.body)
                            .foregroundColor(self.addNewShoppingItemViewModel.priority == .high ? Color.white : Color.primary)
                    }
                    .padding()
                    .background(self.addNewShoppingItemViewModel.priority == .high ? Color("HighPriorityColor") : Color(.systemGray6))
                    .cornerRadius(10)
                    
                    // Nomal Priority Button
                    Button {
                        self.addNewShoppingItemViewModel.priority = .normal
                    } label: {
                        Text("Normal")
                            .lineLimit(1)
                            .font(.body)
                            .foregroundColor(self.addNewShoppingItemViewModel.priority == .normal ? Color.white : Color.primary)
                    }
                    .padding()
                    .background(self.addNewShoppingItemViewModel.priority == .normal ? Color("MediumPriorityColor") : Color(.systemGray6))
                    .cornerRadius(10)
                    
                    // Low Priority Button
                    Button {
                        self.addNewShoppingItemViewModel.priority = .low
                    } label: {
                        Text("Low")
                            .lineLimit(1)
                            .font(.body)
                            .foregroundColor(self.addNewShoppingItemViewModel.priority == .low ? Color.white : Color.primary)
                    }
                    .padding()
                    .background(self.addNewShoppingItemViewModel.priority == .low ? Color("LowPriorityColor") : Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.bottom)
                
                // Save Button
                Button {
                    self.saveShoppingItem()
                    self.isShowing = false
                } label: {
                    Text("Save")
                        .font(.system(.headline, design: .rounded))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(dataSource.selectedTheme.primaryColor))
                        .cornerRadius(10, antialiased: true)
                }
            }
            .padding()
            .background(colorScheme == .light ? .white: Color(.systemGray6))
            .cornerRadius(10, antialiased: true)
        }
    }
    
    private func saveShoppingItem() {
        let newShoppingItem = newShoppingItem ?? ShoppingItemModel(context: context)
        newShoppingItem.id = UUID()
        newShoppingItem.name = addNewShoppingItemViewModel.name
        newShoppingItem.priority = addNewShoppingItemViewModel.priority
        
        do {
            try context.save()
        } catch {
            print("Failed to save data \(error.localizedDescription)")
        }
    }
}

// MARK: - Preivew
struct NewShoppingItemView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let previewShoppingItems = ShoppingItemModel(context: context)
        AddNewShoppingItemView(isShowing: .constant(true), newShoppingItem: previewShoppingItems)
    }
}

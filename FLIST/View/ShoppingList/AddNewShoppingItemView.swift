//
//  NewShoppingItemView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/8.
//

// 588 頁現在看到
import SwiftUI

struct AddNewShoppingItemView: View {
    
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
                        .fontWeight(.black)
                        .foregroundColor(.orange)
                    
                    Spacer()
                    
                    Button {
                        isShowing = false
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.gray)
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
                    
                    Button {
                        self.addNewShoppingItemViewModel.priority = .high
                    } label: {
                        Text("High")
                            .lineLimit(1)
                            .font(.headline)
                            .foregroundColor(self.addNewShoppingItemViewModel.priority == .high ? Color.white : Color.primary)
                    }
                    .padding()
                    .background(self.addNewShoppingItemViewModel.priority == .high ? Color.red : Color(.systemGray6))
                    .cornerRadius(10)
                    
                    Button {
                        self.addNewShoppingItemViewModel.priority = .normal
                    } label: {
                        Text("Normal")
                            .lineLimit(1)
                            .font(.headline)
                            .foregroundColor(self.addNewShoppingItemViewModel.priority == .normal ? Color.white : Color.primary)
                    }
                    .padding()
                    .background(self.addNewShoppingItemViewModel.priority == .normal ? Color.orange : Color(.systemGray6))
                    .cornerRadius(10)
                    
                    Button {
                        self.addNewShoppingItemViewModel.priority = .low
                    } label: {
                        Text("Low")
                            .lineLimit(1)
                            .font(.headline)
                            .foregroundColor(self.addNewShoppingItemViewModel.priority == .low ? Color.white : Color.primary)
                    }
                    .padding()
                    .background(self.addNewShoppingItemViewModel.priority == .low ? Color.green : Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.bottom)
                
                // Save Button
                Button {
                    self.saveShoppingItem()
                    self.isShowing = false
                    // TODO: 有輸入文字再儲存
//                    if self.$addNewShoppingItemViewModel.name.trimmingCharacters(in: .whitespaces) == "" {
//                        return
//                    }
                    
                } label: {
                    Text("Save")
                        .font(.system(.headline, design: .rounded))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(.mint)
                        .cornerRadius(10, antialiased: true)
                }
            }
            .padding()
            .background(.white)
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

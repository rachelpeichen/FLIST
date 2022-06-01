//
//  AddNewItemView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/25.
//

import SwiftUI

struct AddNewItemView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject private var addNewItemViewModel: AddNewItemViewModel
    @State var isNavigationLinkActive = false
    
    var showingDeleteButton: Bool = false
    var newItem: ItemModel?
    
    init(newItem: ItemModel? = nil, showDeleteButton: Bool = false) {
        self.newItem = newItem
        self.addNewItemViewModel = AddNewItemViewModel(itemModel: newItem)
        self.showingDeleteButton = showDeleteButton
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemMint, .font: UIFont(name: "ArialRoundedMTBold", size: 30)!]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
    }

    var body: some View {
        
        
        NavigationView {
            
            ScrollView(.vertical, showsIndicators: true) {
                
                VStack {
                    // Alert Text
                    Group {
                        if !addNewItemViewModel.isNameValid {
                            ValidationErrorText(text: "Please enter the item name")
                        }
                        
                        if !addNewItemViewModel.isQuantityValid {
                            ValidationErrorText(text: "Please enter a valid amount")
                        }
                    }
                    
                    // Name Textfield
                    FormTextField(name: "Name", placeHolder: "Enter new item name", value: $addNewItemViewModel.name)
                        .padding(.top)
                    
                    // Category Selection
                    HStack(spacing: 0) {
                        VStack(alignment: .leading) {
                            
                            Text("Category")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.primary)

                            
                            NavigationLink(destination: CategoryFormView(value: $addNewItemViewModel.category), isActive: $isNavigationLinkActive) {
                                Button(action: {
                                    self.isNavigationLinkActive = true
                                }) {
                                    Text(addNewItemViewModel.category.categoryString)
                                        .font(.system(.body, design: .rounded))
                                        .foregroundColor(addNewItemViewModel.category.color)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(addNewItemViewModel.category.color, lineWidth: 1)
                                        )
                                        .frame(height: 44)
                                }
                            }
                        }
                        .padding(.top)
                        
                        Spacer()
                    }

                    // Amount Textfield
                    FormAmountField(name: "Amount", placeHolder: "1", value: $addNewItemViewModel.quantity)
                        .padding(.top)
                    
                    // Dates
                    VStack(alignment: .leading) {
                        FormDateField(name: "Purchase Date", value: $addNewItemViewModel.purchaseDate)
                            .padding(.bottom)
                        
                        FormDateField(name: "Expired Date", value: $addNewItemViewModel.expiredDate)
                            .padding(.bottom)
                    }
                    .padding(.top)
                    
                    // Memo
                    FormTextEditor(name: "Memo (Optional)", value: $addNewItemViewModel.memo)
                        .padding(.top)
                    
                    // Save Button
                    Button {
                        self.saveItem()
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Save")
                            .font(.system(.headline, design: .rounded))
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(.mint)
                            .cornerRadius(10, antialiased: true)
                    }
                    .padding()
                    
                    // Delete Button
                    if showingDeleteButton {
                        Button {
                            if let item = newItem {
                                self.deleteItem(item)
                            }
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Delete")
                                .font(.system(.headline, design: .rounded))
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(.gray)
                                .cornerRadius(10, antialiased: true)
                        }
                        .padding()
                    }
                }
                .padding()
            }
            .navigationBarTitle("New Item")
        }
    }
    
    // Save the item using Core Data
    private func saveItem() {
        let newItem = newItem ?? ItemModel(context: context)
        newItem.itemId = UUID()
        newItem.category = addNewItemViewModel.category
        newItem.name = addNewItemViewModel.name
        newItem.quantity = Double(addNewItemViewModel.quantity)!
        newItem.purchaseDate = addNewItemViewModel.purchaseDate
        newItem.expiredDate = addNewItemViewModel.expiredDate
        newItem.memo = addNewItemViewModel.memo
        
        do {
            try context.save()
        } catch {
            print("Failed to save data \(error.localizedDescription)")
        }
    }
    
    
    private func deleteItem(_ item: ItemModel) {
        self.context.delete(item)
        
        DispatchQueue.main.async {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Preview

struct AddNewItemView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let previewItems = ItemModel(context: context)
        AddNewItemView(newItem: previewItems, showDeleteButton: true)
            .frame(height: nil)
            .previewDevice("iPhone 11")
    }
}

// MARK: - Extracted Views

struct ValidationErrorText: View {
    var iconName = "info.circle"
    var iconColor = Color(red: 251/255, green: 128/255, blue: 128/255)
    var text = ""
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(iconColor)
            Text(text)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}

struct FormTextField: View {
    let name: String
    var placeHolder: String
    
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            TextField(placeHolder, text: $value)
                .font(.headline)
                .foregroundColor(.primary)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .submitLabel(.done)
        }
    }
}

struct FormAmountField: View {
    let name: String
    var placeHolder: String
    
    @Binding var value: String
    //    @FocusState var isInputActive: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            TextField(placeHolder, text: $value)
                .font(.headline)
                .foregroundColor(.primary)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .keyboardType(.decimalPad)
            // 現在要加 done 這沒用不知為何 舊方法又麻煩
            //                .focused($isInputActive)
            //                .toolbar {
            //                    ToolbarItem(placement: .keyboard) {
            //                        Button("Done") {
            //                            isInputActive = false
            //                        }
            //                    }
            //                }
        }
    }
}

struct FormDateField: View {
    let name: String
    
    @Binding var value: Date?
    @State var showDatePicker = false
    
    var body: some View {
        VStack {
            HStack() {
                Text(name)
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Toggle("", isOn: $showDatePicker)
                    .toggleStyle(SwitchToggleStyle(tint: .mint))
                    .font(.system(.subheadline, design: .rounded))
            }
            
            if showDatePicker {
                HStack {
                    Spacer()
                    DatePicker("", selection: Binding<Date>(get: {self.value ?? Date()}, set: {self.value = $0}), displayedComponents: .date)
                        .accentColor(.orange)
                        .padding(10)
                        .cornerRadius(10)
                        .labelsHidden()
                }
            }
        }
    }
}

struct FormTextEditor: View {
    let name: String
    var height: CGFloat = 80.0
    
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            TextEditor(text: $value)
                .frame(minHeight: height)
                .colorMultiply(Color(.systemGray6))
                .cornerRadius(10)
                .font(.headline)
                .foregroundColor(.primary)
                .submitLabel(.done)
        }
    }
}

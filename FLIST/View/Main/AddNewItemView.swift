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
    
    @EnvironmentObject var userSetting: UserSetting
    
    @ObservedObject private var addNewItemViewModel: AddNewItemViewModel
    
    @State var isNavigationLinkActive = false
    
    var showingDeleteButton: Bool = false
    var itemToEdit: ItemModel?
    var title: String {
        itemToEdit == nil ? "Create New Item" : "Edit Item"
    }
    
    init(editItem: ItemModel? = nil, showDeleteButton: Bool = false) {
        self.itemToEdit = editItem
        self.addNewItemViewModel = AddNewItemViewModel(itemModel: editItem)
        self.showingDeleteButton = showDeleteButton
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
                                    Text(addNewItemViewModel.category.icon)
                                    Text(addNewItemViewModel.category.categoryString)
                                        .font(.system(.body, design: .rounded))
                                        .foregroundColor(.primary)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(.gray, lineWidth: 1)
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
                            .background(Color(userSetting.selectedTheme.primaryColor))
                            .cornerRadius(10, antialiased: true)
                    }
                    .padding()
                    
                    // Delete Button
                    if showingDeleteButton {
                        Button {
                            if let item = itemToEdit {
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
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarModifier(textColor: userSetting.selectedTheme.primaryColor)
        }
    }
    
    // Save the item using Core Data
    private func saveItem() {
        let newItem = itemToEdit ?? ItemModel(context: context)
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
        AddNewItemView(editItem: previewItems, showDeleteButton: true)
            .frame(height: nil)
            .environmentObject(UserSetting())
    }
}

// MARK: - Extracted Views

struct ValidationErrorText: View {
    
    @EnvironmentObject var dataSource: UserSetting
    var iconName = "info.circle"
    var text = ""
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(Color(dataSource.selectedTheme.primaryColor))
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
    
    @Environment(\.colorScheme) var colorScheme
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
                .background(colorScheme == .light ? Color(.systemGray6): Color(.systemGray4))
                .cornerRadius(10)
                .submitLabel(.done)
        }
    }
}

struct FormAmountField: View {
    let name: String
    var placeHolder: String
    
    @Environment(\.colorScheme) var colorScheme
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
                .background(colorScheme == .light ? Color(.systemGray6): Color(.systemGray4))
                .cornerRadius(10)
                .keyboardType(.decimalPad)
        }
    }
}

struct FormDateField: View {
    let name: String
    
    @EnvironmentObject var dataSource: UserSetting
    @Binding var value: Date?
    @State var showDatePicker = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Text(name)
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Toggle("", isOn: $showDatePicker)
                    .toggleStyle(SwitchToggleStyle(tint: Color(dataSource.selectedTheme.primaryColor)))
                    .font(.system(.subheadline, design: .rounded))
            }
            
            Text(value?.asString() ?? "")
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.primary)
            
            if showDatePicker {
                HStack {
                    Spacer()
                    DatePicker("", selection: Binding<Date>(get: {self.value ?? Date()}, set: {self.value = $0}), displayedComponents: .date)
                        .accentColor(Color(dataSource.selectedTheme.primaryColor))
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

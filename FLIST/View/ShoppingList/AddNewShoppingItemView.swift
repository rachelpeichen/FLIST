//
//  NewShoppingItemView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/8.
//

import SwiftUI

struct AddNewShoppingItemView: View {
    
    // MARK: - Parameters
    @Binding var isShow: Bool
    // @Binding var shoppingItems: [ShoppingItemModel]

    @State var name: String
    @State var priority: Priority
    @State var isEditing = false
    
    var body: some View {
        VStack {
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Add a new shopping item")
                        .font(.system(.title, design: .rounded))
                        .foregroundColor(.orange)
                        .bold()
                    
                    Spacer()
                    
                    Button {
                        self.isShow = false
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.gray)
                            .font(.title)
                    }
                }
                
                TextField("Enter item name", text: $name) { editingChanged in
                    self.isEditing = editingChanged
                }
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(10)
                
                Text("Priority")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.secondary)
                    .padding(.top)
                
                HStack {
                    Text("High")
                        .font(.system(.headline, design: .rounded))
                        .padding(10)
                        .background(priority == .high ? .red : Color(.systemGray4))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .onTapGesture {
                            self.priority = .high
                        }
                    
                    Text("Medium")
                        .font(.system(.headline, design: .rounded))
                        .padding(10)
                        .background(priority == .high ? .orange : Color(.systemGray4))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .onTapGesture {
                            self.priority = .normal
                        }
                    
                    Text("Low")
                        .font(.system(.headline, design: .rounded))
                        .padding(10)
                        .background(priority == .high ? .green : Color(.systemGray4))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .onTapGesture {
                            self.priority = .low
                        }
                }
                .padding(.bottom)
                
                Button {
                    self.isShow = false
                    // add item
                } label: {
                    Text("Save")
                        .font(.system(.headline, design: .rounded))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(.purple)
                        .cornerRadius(10, antialiased: true)
                }
            }
            .padding()
            .background(.white)
            .cornerRadius(10, antialiased: true)
        }
    }
}

struct NewShoppingItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewShoppingItemView(isShow: .constant(true), name: "", priority: .normal)
    }
}

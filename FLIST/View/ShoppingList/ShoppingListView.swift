//
//  ShoppingListView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/7.
//

import SwiftUI

struct ShoppingListView: View {
    
    // MARK: - Parameters
    @State var shoppingItems: [ShoppingItemModel] = []
    @State var showAddNewItemView = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Shopping List")
                        .font(.system(.title, design: .rounded))
                        .foregroundColor(Color.orange)
                        .bold()
                    
                    Spacer()
                    
                    Button {
                        self.showAddNewItemView = true
                    } label : {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.orange)
                            .font(.title)
                    }
                }
                .padding()
                
                List {
                    ForEach(shoppingItems) { item in
                        ShoppingListRow(shoppingItem: item)
                    }
                }
            }
            
            if showAddNewItemView {
                BackgroundView(bgColor: .black)
                    .opacity(0.5)
                    .onTapGesture {
                        self.showAddNewItemView = false
                    }
                
                AddNewShoppingItemView(isShow: $showAddNewItemView, name: "", priority: .normal)
            }
        }
    }
}

struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView()
    }
}

//
//  CategoryFormView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/5/31.
//

import SwiftUI

struct CategoryFormView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userSetting: UserSetting
    @Binding var value: ItemCategory
    
    var body: some View {
        List {
            ForEach(ItemCategory.allCases) { category in
                
                HStack {
                    Text(category.icon)
                    
                    Text(LocalizedStringKey(category.categoryString))
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                .frame(height: 40)
                .onTapGesture {
                    self.value = category
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct CategoryFormView_Previews: PreviewProvider {
    static var previews: some View {
        let previewItemCategory = ItemCategory.fruits
        CategoryFormView(value: .constant(previewItemCategory))
    }
}

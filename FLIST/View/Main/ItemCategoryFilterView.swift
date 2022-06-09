//
//  ItemCategoryFilterView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/5/31.
//

import SwiftUI

struct ItemCategoryFilterView: View {
    
    @EnvironmentObject var userSetting: UserSetting
    @Binding var selectedCategories: Set<ItemCategory>
    private let categories = ItemCategory.allCases
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(categories) { category in
                    FilterButtonView(itemCategory: category,
                                     isSelected: self.selectedCategories.contains(category),
                                     onTapped: { tappedCategory in
                        onTap(category: tappedCategory)
                    })
                    .padding(.leading, category == self.categories.first ? 16 : 0)
                    .padding(.trailing, category == self.categories.last ? 16 : 0)
                }
            }
        }
    }
    
    func onTap(category: ItemCategory) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
}

struct ItemCategoryFilterView_Previews: PreviewProvider {
    static var previews: some View {
        ItemCategoryFilterView(selectedCategories: .constant(Set())).environmentObject(UserSetting())
    }
}

struct FilterButtonView: View {
    
    @EnvironmentObject var userSetting: UserSetting
    
    var itemCategory: ItemCategory
    var isSelected: Bool
    var onTapped: (ItemCategory) -> ()
    
    var body: some View {
        Button(action: {
            self.onTapped(itemCategory)
        }) {
            HStack(spacing: 8) {
                Text(LocalizedStringKey(itemCategory.categoryString))
                    .fixedSize(horizontal: true, vertical: true)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(isSelected ? Color(userSetting.selectedTheme.primaryColor) : .secondary)
                
                if isSelected {
                    Image(systemName: "xmark.circle.fill")
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color(userSetting.selectedTheme.primaryColor) : Color(UIColor.lightGray), lineWidth: 1))
            .frame(height: 40)
        }
        .foregroundColor(isSelected ? Color(userSetting.selectedTheme.primaryColor) : .secondary)
    }
}

//
//  SortSelectorView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/6/7.
//

import SwiftUI

struct SortSelectorView: View {
    
    @EnvironmentObject var userSetting: UserSetting

    @Binding var sortType: SortType
    @Binding var sortOrder: SortOrder
    
    private let sortTypes = SortType.allCases
    private let sortOrders = SortOrder.allCases
    
    var body: some View {
        
        HStack {
            Text("Sort by")
            .font(.system(.subheadline, design: .rounded))
            .foregroundColor(.secondary)
            
            Picker(selection: $sortType, label: Text("Sort by")) {
                ForEach(SortType.allCases) { type in
                    Image(systemName: type == .expiredDate ? "calendar" : "number")
                        .tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .colorMultiply(Color(userSetting.selectedTheme.primaryColor))
            
            Text("Order by")
            .font(.system(.subheadline, design: .rounded))
            .foregroundColor(.secondary)
            
            Picker(selection: $sortOrder, label: Text("Order")) {
                ForEach(sortOrders) { order in
                    Image(systemName: order == .ascending ? "arrow.up" : "arrow.down")
                        .tag(order)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .colorMultiply(Color(userSetting.selectedTheme.primaryColor))
        }
        .padding(.all)
        .frame(height: 60)
    }
}

struct SortSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        SortSelectorView(sortType: .constant(.quantity), sortOrder: .constant(.descending))
    }
}

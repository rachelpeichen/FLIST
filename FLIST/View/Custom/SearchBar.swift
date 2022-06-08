//
//  SearchBar.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/7.
//

import SwiftUI

struct SearchBar: View {
    
    @EnvironmentObject var dataSource: UserSetting
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var text: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            TextField("Search For Items", text: $text)
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.primary)
                .padding(7)
                .padding(.horizontal, 25)
                .background(colorScheme == .light ? Color(.systemGray6): Color(.systemGray4))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing {
                            Button {
                                self.text = ""
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(Color(dataSource.selectedTheme.primaryColor))
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
            
            if isEditing {
                Button {
                    withAnimation {
                        self.isEditing = false
                        self.text = ""
                    }
                    // Dismiss the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                } label: {
                    Text("Cancel")
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.secondary)
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
    }
}

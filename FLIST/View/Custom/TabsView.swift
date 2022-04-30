//
//  TabsView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/7.
//

import SwiftUI

struct Tab {
    var title: String
}

struct TabsView: View {
    
    // MARK: - Parameters
    var fixed = true
    var tabs: [Tab]
    var geoWidth: CGFloat
    
    @Binding var selectedTab: Int 
    
    // MARK: - Body
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                HStack(spacing: 0) {
                    ForEach(0..<tabs.count, id: \.self) { row in
                        Button {
                            withAnimation {
                                selectedTab = row
                            }
                        } label: {
                            VStack(spacing: 0) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                        .fill(selectedTab == row ? Color.orange : Color.clear)
                                        .frame(width: fixed ? abs((geoWidth / CGFloat(tabs.count) - 20)) : .none, height: 40)
                                    
                                    Text(tabs[row].title)
                                        .font(Font.system(size: 18, weight: .regular, design: .rounded))
                                        .foregroundColor(selectedTab == row ? Color.white : Color.secondary)
                                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                                }
                            }
                            .frame(width: fixed ? (geoWidth / CGFloat(tabs.count)) : .none, height: 50)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .accentColor(Color.orange)
                    }
                }
                .onChange(of: selectedTab) { newValue in
                    withAnimation {
                        proxy.scrollTo(newValue)
                    }
                }
            }
        }
        .frame(height: 60)
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView(tabs: [.init(title: "Fridge"),
                        .init(title: "Freezer"),
                        .init(title: "Others")],
                 geoWidth: 400,
                 selectedTab: .constant(0))
    }
}

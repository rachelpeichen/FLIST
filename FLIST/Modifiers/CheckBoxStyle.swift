//
//  CheckBoxStyle.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/8.
//

import SwiftUI

struct CheckboxStyle: ToggleStyle {
    
    @EnvironmentObject var dataSource: UserSetting
    
    func makeBody(configuration: Self.Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(configuration.isOn ? Color(dataSource.selectedTheme.primaryColor) : Color(.lightGray.withAlphaComponent(0.5)))
                .font(.system(size: 20, weight: .light, design: .default))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            
            configuration.label
        }
    }
}


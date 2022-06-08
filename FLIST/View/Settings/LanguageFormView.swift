//
//  LanguageFormView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/6/8.
//

import SwiftUI

struct LanguageFormView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userSetting: UserSetting

    var body: some View {
        List {
            ForEach(Localication.allCases) { local in
                HStack {
                    Text(local.displayedLanguage.rawValue)
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.primary)
                    Spacer()
                }
                .frame(height: 40)
                .onTapGesture {
                    userSetting.selectedLanguage = local
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct LanguageFormView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageFormView()
    }
}

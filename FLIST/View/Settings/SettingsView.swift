//
//  SettingsView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/7.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var userSetting: UserSetting
    
    @State var selectedTheme: Int = 0
    @State var isNavigationLinkActive = false
    
    let columns = [GridItem(.adaptive(minimum: 60), spacing: 10)]
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                
                HStack {
                    Text("Settings")
                        .font(.system(.title, design: .rounded))
                        .foregroundColor(Color(userSetting.selectedTheme.primaryColor))
                        .bold()
                    
                    Spacer()
                }
                .padding()
                
                VStack {
                    VStack(alignment: .leading) {
                        Text("Theme Color")
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.primary)
                        
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(0..<ThemeManager.themes.count, id: \.self) { theme in
                                
                                Button {
                                    userSetting.selectedThemeAs = theme
                                    selectedTheme = theme
                                } label: {
                                    Text("")
                                        .frame(width: 60, height: 60)
                                        .background(Color(ThemeManager.themes[theme].primaryColor))
                                        .clipShape(Circle())
                                }
                                .overlay(alignment: .bottomTrailing) {
                                    if theme == selectedTheme {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.gray)
                                            .offset(x: 6, y: 2)
                                    }
                                }
                                
                            }
                        }
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Text("App Language")
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            NavigationLink(destination: LanguageFormView(), isActive: $isNavigationLinkActive) {
                                Button(action: {
                                    self.isNavigationLinkActive = true
                                }) {
                                    Text(userSetting.selectedLanguage.displayedLanguage.rawValue)
                                        .font(.system(.body, design: .rounded))
                                        .foregroundColor(Color(userSetting.selectedTheme.primaryColor))
                                    
                                    Image(systemName: "chevron.forward")
                                        .padding()
                                }
                            }
                        }
                    }
                    .padding()
                    
                }
            }
            .environment(\.locale, .init(identifier: userSetting.selectedLanguage.rawValue))
            .navigationBarModifier(textColor: userSetting.selectedTheme.primaryColor)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Initializer
    init() {
        let design = UIFontDescriptor.SystemDesign.rounded
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle:
                .headline)
            .withDesign(design)!
        let font = UIFont.init(descriptor: descriptor, size: 30)
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : font, .foregroundColor: UIColor.orange]
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(UserSetting())
    }
}


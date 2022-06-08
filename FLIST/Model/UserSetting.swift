//
//  DataSource.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/6/7.
//

import SwiftUI

class UserSetting: ObservableObject {
    @AppStorage("selectedTheme") var selectedThemeAs = 0 {
        didSet {
            updateTheme()
        }
    }
    
    @AppStorage("selectedLanguage") var selectedLanguage = Localication.en

    init() {
        updateTheme()
    }
    
    @Published var selectedTheme: Theme = BlueTheme()
    
    func updateTheme() {
        selectedTheme = ThemeManager.getTheme(selectedThemeAs)
    }
}

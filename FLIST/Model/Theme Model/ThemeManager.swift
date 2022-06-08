//
//  ThemeManager.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/6/7.
//

import Foundation

enum ThemeManager {
    static let themes: [Theme] = [
        BlueTheme(), GreenTheme(), CyanTheme(), GeekBlueTheme(), PurpleTheme(),
        RedTheme(), PinkTheme(), OrangeTheme(), GoldTheme(), SimpleTheme()
    ]
    
    static func getTheme(_ theme: Int) -> Theme {
        Self.themes[theme]
    }
}

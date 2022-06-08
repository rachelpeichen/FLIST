//
//  LocalizationModel.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/6/8.
//

import Foundation

enum Localication: String, CaseIterable {
    case zh_Hant = "zh_Hant"
    case en = "en"
}

extension Localication: Identifiable {
    var id: String { self.rawValue }
}

extension Localication {
    var displayedLanguage: LocalStrings {
        switch self {
        case .zh_Hant:
            return .zh_Hant
        case .en:
            return .en
        }
    }
}

// To show for user
enum LocalStrings: String, CaseIterable {
    case zh_Hant = "繁體中文"
    case en = "English"
}

extension LocalStrings: Identifiable {
    var id: String { self.rawValue }
}

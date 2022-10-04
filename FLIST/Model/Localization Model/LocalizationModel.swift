//
//  LocalizationModel.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/6/8.
//

import Foundation

enum Localication: String, CaseIterable {
    case en = "en"
    case zh_Hant = "zh_Hant"
    case zh_Hans = "zh_Hans"
}

extension Localication: Identifiable {
    var id: String { self.rawValue }
}

extension Localication {
    var displayedLanguage: LocalStrings {
        switch self {
        case .en:
            return .en
        case .zh_Hant:
            return .zh_Hant
        case .zh_Hans:
            return .zh_Hans
        }
    }
}

// To show for user
enum LocalStrings: String, CaseIterable {
    case en = "English"
    case zh_Hant = "繁體中文"
    case zh_Hans = "简体中文"
}

extension LocalStrings: Identifiable {
    var id: String { self.rawValue }
}

//
//  Date+Extension.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/27.
//

import Foundation
import SwiftUI

extension Date {
    
    static var today: Date {
        return Date()
    }
    
    static var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }
    
    func asString(with format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

//extension LocalizedStringKey {
//    var stringKey: String? {
//        Mirror(reflecting: self).children.first(where: { $0.label == "key" })?.value
//    }
//}
//
//extension String {
//    static func localizedString(for key: String,
//                                locale: Locale = .current) -> String {
//
//        let language = locale.languageCode
//        let path = Bundle.main.path(forResource: language, ofType: "lproj")!
//        let bundle = Bundle(path: path)!
//        let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")
//
//        return localizedString
//    }
//}
//
//extension LocalizedStringKey {
//    func stringValue(locale: Locale = .current) -> String {
//        return .localizedString(for: self.stringKey, locale: locale)
//    }
//}

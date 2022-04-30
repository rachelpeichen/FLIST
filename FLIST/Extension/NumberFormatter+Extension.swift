//
//  NumberFormatter+Extension.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/30.
//

import Foundation

extension NumberFormatter {
    
    static func asString(from value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedValue = formatter.string(from: NSNumber(value: value)) ?? ""
        return formattedValue
    }
}

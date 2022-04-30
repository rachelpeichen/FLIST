//
//  Date+Extension.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/27.
//

import Foundation

extension Date {
    
    static var today: Date {
        return Date()
    }
    
    static var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }
    
    static var tenYear: Date {
        return Calendar.current.date(byAdding: .day, value: 3650, to: Date())!
    }
    
    func asString(with format: String = "dd MMM yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

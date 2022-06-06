//
//  Binding+Extension.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/30.
//

import SwiftUI

extension Binding {
    
    init<T>(isNotNil source: Binding<T?>, defaultValue: T) where Value == Bool {
        self.init(get: { source.wrappedValue != nil },
                  set: { source.wrappedValue = $0 ? defaultValue : nil})
    }
}

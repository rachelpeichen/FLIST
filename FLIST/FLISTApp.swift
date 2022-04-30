//
//  FLISTApp.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/6.
//

import SwiftUI

@main
struct FLISTApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

//
//  ContentView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/6.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    //@Environment(\.managedObjectContext) var context
    
    @State private var selectedTag = 1

    var body: some View {
        ZStack {
            TabView(selection: $selectedTag) {
                ShoppingListView()
                .tag(0)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Shooping List")
                }
                
                MainView()
                .tag(1)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                
                SettingsView()
                .tag(2)
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
            }
            .accentColor(Color.orange)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

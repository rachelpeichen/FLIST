//
//  SettingsView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/7.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .navigationTitle("Settings")
        }
    }
    
    // MARK: - Initializer
    init() {
        let design = UIFontDescriptor.SystemDesign.rounded
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle:
                .headline)
            .withDesign(design)!
        let font = UIFont.init(descriptor: descriptor, size: 30)
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : font, .foregroundColor: UIColor.orange]
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

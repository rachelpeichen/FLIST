//
//  NavigationBarModifier.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/6/7.
//
// Refer tp this video: https://youtu.be/XdfVPPfnZZU
import SwiftUI

struct NavigationBarModifier: ViewModifier {
    
    let textColor: UIColor

    init(textColor: UIColor) {
        self.textColor = textColor
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: textColor, .font: UIFont(name: "ArialRoundedMTBold", size: 24)!]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: textColor, .font: UIFont(name: "ArialRoundedMTBold", size: 30)!]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = textColor
    }

    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func navigationBarModifier(textColor: UIColor) -> some View {
        self.modifier(NavigationBarModifier(textColor: textColor))
    }
}

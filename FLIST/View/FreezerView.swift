//
//  FreezerView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/7.
//

import SwiftUI

struct FreezerView: View {
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.737254902, green: 0.1294117647, blue: 0.2941176471, alpha: 1))
            Text("Tabs2View")
                .foregroundColor(.white)
                .font(Font.system(size: 25, weight: .bold))
        }
    }
}

struct Tabs2View_Previews: PreviewProvider {
    static var previews: some View {
        FreezerView()
    }
}

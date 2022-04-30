//
//  BackgroundView.swift
//  FLIST
//
//  Created by Rachel Chen on 2022/4/9.
//

import SwiftUI

struct BackgroundView: View {
    
    var bgColor: Color
    
    var body: some View {
        VStack {
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(bgColor)
        .edgesIgnoringSafeArea(.all)
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView(bgColor: .black)
    }
}

//
//  BannerModifier.swift
//  SecondSave
//
//  Created by IDEA Lab on 2021/4/12.
//

import SwiftUI

struct BannerModifier: View {
    var body: some View {
        Text("Data Copied!")
            .padding()
            .frame(width: UIScreen.main.bounds.width - 44, height: 50)
            .background(Color.gray.opacity(0.2))
            .foregroundColor(.white)
            .cornerRadius(8)
            .font(Font.custom("PresicavRg-Bold", size: 16))
    }
}

struct BannerModifier_Previews: PreviewProvider {
    static var previews: some View {
        BannerModifier()
    }
}

//
//  BannerModifier.swift
//  SecondSave
//
//  Created by IDEA Lab on 2021/4/12.
//

import SwiftUI

struct BannerModifier: View {
    var body: some View {
        //Image("play.fill")
        
        Text("Data Copied!")
            .padding()
            //.frame(width: UIScreen.main.bounds.width - 44, height: 50)
            .frame(width: 190, height: 80, alignment: .center)
            .background(Color(UIColor(red: 49/255, green: 49/255, blue: 51/255, alpha: 1)))
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

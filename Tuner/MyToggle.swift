//
//  MyToggle.swift
//  Tuner
//
//  Created by Ashish on 28/03/25.
//

import SwiftUI

struct MyToggle: View {
    @Binding var isOn:Bool
    var body: some View {
        ZStack{
            Rectangle().frame(width:90,height:46).cornerRadius(25).foregroundColor(isOn ? .green : .white )
            Text("Auto").font(.custom("GeneralSansVariable-Bold_Regular",size: 15)).fontWeight(.semibold).foregroundColor( isOn ? .white : .gray
            ).offset(x:isOn ? -17:17,y:-1)
            Circle().frame(width:50,height: 40).foregroundColor(Color.white).offset(x: isOn ? 24:-24).shadow(color:.gray, radius: 12).onTapGesture {
                withAnimation{
                    isOn.toggle()
                }
                
            }
        }
    }
}

#Preview {
    @Previewable @State var v:Bool=false
    MyToggle(isOn: $v)
}

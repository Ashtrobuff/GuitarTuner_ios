//
//  BottomPart.swift
//  Tuner
//
//  Created by Ashish on 17/03/25.
//

import SwiftUI

struct BottomPart: View {
    var body: some View {
        ZStack
        {
            Button{
                
            }label:{
                ZStack{

                    
                    Image("sushi").resizable()
                    LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear,Color.clear]), startPoint: .bottomLeading, endPoint: .topTrailing)
                    VStack{
                        Spacer()
                        Text("Salmon Sushi Matcha").font(.largeTitle).foregroundColor(.white).bold().multilineTextAlignment(.leading).offset(x:-20,y:-50)
                        Text("Salmon Sushi Matcha | 50mins").font(.caption).foregroundColor(.white).multilineTextAlignment(.leading).offset(x:-50,y:-40)
                    }
                    ZStack{
                        Color.black.opacity(0.5).blur(radius: 0.5)
                        Image(systemName:"bookmark.fill").foregroundColor(Color.white)
                    }.cornerRadius(16).frame(width:55,height:55,alignment: .trailing).offset(x:110,y:-160)
                }
            }
        }.background(LinearGradient(gradient: Gradient(colors: [Color.clear, Color.clear,Color.black.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)).frame(width:300,height:400).cornerRadius(16)
    }
}

#Preview {
    BottomPart()
}

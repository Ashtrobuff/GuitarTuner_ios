//
//  BubbleButtons.swift
//  Tuner
//
//  Created by Ashish on 17/03/25.
//

import SwiftUI

struct BubbleButtons: View {
    let cats:[String]=["All","Sushi","Burgers","Gourmet","Porridges"]
    @Binding var selectedType:String
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false){
            HStack{
            ForEach(cats,id:\.self)
            {
                i in
                Button{
                    selectedType=i
                }
                label:{
                    ZStack{
                        Text(i).foregroundColor(self.selectedType==i ? Color.white : Color.black.opacity(0.5)).font(.headline).bold()
                    }.frame(minWidth:60).padding(16).background( self.selectedType==i ? LinearGradient(gradient: Gradient(colors: [Color(hex: "ff66bb6a"), .green, Color(hex: "ff81c784")]), startPoint: .topLeading, endPoint: .bottomTrailing) :  LinearGradient(gradient: Gradient(colors: [.white, .white,.white]), startPoint: .topLeading, endPoint: .bottomTrailing)).cornerRadius(16).onTapGesture {
                      
                    }
                }
            
                
            }
        }
        }
     
    }
}

//#Preview {
//    BubbleButtons()
//}

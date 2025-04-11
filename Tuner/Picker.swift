//
//  Picker.swift
//  Tuner
//
//  Created by Ashish on 27/03/25.
//

import SwiftUI
struct StringPicker: View {
    let columns = [GridItem(.flexible(),spacing:200), GridItem(.flexible())]
     @Binding var selectedFrequency:String
    let stringNames=["E2","A2","D3","G3","B3","E4"]
    var body: some View {
        LazyVGrid(columns:columns,spacing:30){
            ForEach(stringNames,id:\.self)
            {
                v in
                Button(action:{
                    selectedFrequency=v
                    
                    print(selectedFrequency)
                }){
                    
                    Text("\(v)").foregroundColor(selectedFrequency==v ? .white : .gray).padding(10)
                }.overlay{
                    RoundedRectangle(cornerRadius:30)
                        .stroke(selectedFrequency==v ? .white : .gray, lineWidth: 2)
//                    RoundedRectangle(cornerRadius: 30).fill(.clear).border(.white, width: 2).cornerRadius(30)
                }
                
//                {
//                    ZStack{
//                    Text("\(v)").font(.custom("GeneralSansVariable-Bold_Regular",size: 30)).foregroundColor(selectedFrequency==v ?
//                                                                                                            Color(hex: "#174bb3") : Color.white ).fontWeight(.medium)
//                    Circle().foregroundColor(selectedFrequency==v ? Color.white : Color.white.opacity(0.5)).frame(width:55,height:55).onTapGesture {
//                        self.opacity(0.3)
//                    }
//                }
                
//                }.frame(width:55,height:55).cornerRadius(25)
            }
        }
    }
    
    struct GrowingButton: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
                
            configuration.label
                .padding()
                .background()
                .foregroundStyle(.black)
                .clipShape(Capsule())
                .scaleEffect(configuration.isPressed ? 1.2 : 1)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
        }
    }
    
    struct GrowingButton2: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
                
            configuration.label
                .padding()
                .background()
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .scaleEffect(configuration.isPressed ? 1.2 : 1)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
        }
    }
}

#Preview {
    @Previewable @State var selecr:String="E2"
    StringPicker(selectedFrequency: $selecr)
}

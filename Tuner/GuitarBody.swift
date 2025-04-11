//
//  Button.swift
//  Tuner
//
//  Created by Ashish on 27/03/25.
//

import Foundation
import SwiftUI
struct GuitarBody:View{
    @Binding var needlePos:CGFloat
    @ObservedObject var engine:TunerEngine
    @State private var time: Float = 0.0
    var width=UIScreen.main.bounds.width
    var body:some View
    {ZStack{
//        
//        MeshGradient(width: 3, height: 3, points: [
//            [0, 0], [0.5, 0],[1,0],
//            [0,0.5], [1, 1],[1,1],
//            [0,1],[0.5,1.0],[0.5,1]
//        ], colors: [.red, .blue, .init(hex: "ffffff"),
//                    .init(hex: "bb9e65"),.init(hex: "174bb3")
//                    ,.black
//                    ,.blue,.init(hex: "174bb3"),.init(hex: "ffffff")
//        ]).ignoresSafeArea()
//
        Color.black.opacity(60).ignoresSafeArea()
        VStack{
            HStack{
                VStack(alignment:.leading){
                Text("Guitar.").font(.custom("GeneralSansVariable-Bold_Regular",size: 80)).foregroundColor(Color.white.opacity(1)).fontWeight(.semibold).multilineTextAlignment(.leading).tracking(-3)
                Text("Standard").font(.custom("GeneralSansVariable-Bold_Regular",size: 75)).foregroundColor(Color.white.opacity(0.4)).fontWeight(.semibold).multilineTextAlignment(.leading).offset(y:-20).tracking(-4);
            }
                Spacer()
            }.padding(.horizontal,5)
            HStack{Spacer()
                MyToggle(isOn: $engine.isonAuto)}.padding(.horizontal,20)
            ZStack{
                Rectangle().fill(.clear).frame(width:350,height:200).cornerRadius(20).offset(y:-70).shadow(radius: 2)
                TopPart(offset:$needlePos)
                needle(offset:$needlePos)
            }
        //    stub().fill(.white)
      
            StringPicker(selectedFrequency:$engine.stringSelection).offset(y:-30)
            
            Spacer()
        }.frame(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height).padding(.top,60).padding(.leading,0)
//        Image("head2").background(Color.clear).foregroundStyle(.clear).foregroundColor(.clear).scaledToFit().offset(x:-10,y:350).foregroundColor(.white).opacity(0.8).scaleEffect(0.8)
    }
    }
    func calculate_roundedPOS()->CGFloat
    {       print( "the offset\(round(self.needlePos))")
        return round(self.needlePos)
    }
}

#Preview
{
    @State var needlepos:CGFloat=0.0
    @ObservedObject var engine=TunerEngine()
    GuitarBody(needlePos: $needlepos, engine:engine)
}


//GeometryReader{
//    geometry in
//    Path{
//        path in
//        var width = min(geometry.size.width, geometry.size.height)
//        let height=100.00
//        path.move(to: CGPoint(x:width*0.99,y:height*0.01))
//        GuitarPath.segements.forEach{
//            segment in
//            path.addLine(to: CGPoint(x:width*segment.line.x,y:height*segment.line.y))
//            path.addCurve(
//                to: CGPoint(
//                    x: width * segment.curve.x,
//                    y: height * segment.curve.y
//                ),
//                control1: CGPoint(
//                    x: width * segment.contorl1.x,
//                    y: height * segment.contorl1.y
//                ), control2: CGPoint(x:width*segment.contorl2.x,y:height*segment.contorl2.y)
//            )
//            
//        }
//        
//    }.fill(.pink).clipped(antialiased: true)
//}

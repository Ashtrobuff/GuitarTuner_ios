//
//  needle.swift
//  Tuner
//
//  Created by Ashish on 27/03/25.
//

import Foundation
import SwiftUI
struct needle:View{
    @Binding  var offset:CGFloat
    var body:some View{
        ZStack{
            pin().fill(.white).rotationEffect(.degrees(CGFloat(calcOffset(offset: offset)))).animation(.linear(duration: 0.2)).shadow(color:.white,radius: 20)
          //  stub().fill(.white)
        }.frame(width:200,height:90)
    }
    func calcOffset(offset:CGFloat)->CGFloat
    {
        let width=UIScreen.main.bounds.width
        let halfer=width/2
        print(offset)
        if(self.offset >= 90)
        {
            return 90
        }else if( self.offset <= -90)
        {
            return -90
        }else{
            return offset
        }
    
         
        
    }
}
//#Preview
//{ @Previewable @State var offset:CGFloat = 800
//    needle(offset: offset)
//}


struct pin:Shape{
    func path(in rect: CGRect) -> Path {
        var path=Path()
        path.move(to: CGPoint(x: rect.midX ,y:rect.minY-70))
        path.addArc(center:CGPoint(x: rect.midX, y: rect.maxY-50), radius: rect.maxX*(1/30), startAngle: .degrees(-180), endAngle:.degrees(0), clockwise: true)
     
        return path
    }
    
    
}

struct stub:Shape{
    func path(in rect: CGRect) -> Path {
        var path=Path()
        path.move(to: CGPoint(x: rect.midX ,y:rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        return path
    }
    
    
}




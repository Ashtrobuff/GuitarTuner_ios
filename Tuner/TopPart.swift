//
//  TopPart.swift
//  Tuner
//
//  Created by Ashish on 17/03/25.
//

import SwiftUI

struct TopPart: View {
    @Binding var offset:CGFloat{
        didSet{
            isClock()
        }}
    
    @State var isClockwise:Bool=true
    var body: some View {
        ZStack{
//            Circle().trim(from:-1,to:-0.05).stroke(.blue,lineWidth: 10).rotationEffect(.degrees(-90))
//            Arc(startAngle: .degrees(0), endAngle: Angle(degrees: offset<0 ? -Double(offset) /*Double(offset) - .pi*2*/ : Double(offset) ), clockwise: offset<0).stroke(abs(offset)>30 ? .red: .orange, lineWidth: 10)
//                    .frame(width: 300, height: 300).shadow(color:abs(offset)>30 ? .red: .orange,radius: 10)
            
            NeedleArc(angle: .degrees(Double(calcOffset(offset: offset))))
                .stroke(abs(offset) == 0 ? .green : .orange, lineWidth: 6)
                .shadow(color: abs(offset) > 30 ? .red : .orange, radius: 4)

            
        ZStack
        {
            ForEach(-15..<16)
            { i in
                if (i==0)
                {
                    Rectangle().frame(width:2,height:20).offset(y:-140).shadow(color:.white,radius: 2).foregroundColor(.white)
                }else
                {
                    Tick().stroke(.white,lineWidth: 1.3).rotationEffect(.radians((.pi*2/60)*Double(i))).shadow(color:.white,radius: 2)
                }
            }
            
        }.shadow(color:.white,radius: 5)
        }.frame(width:300,height:300,alignment:.center)
    }
    func isClock()
    {
        if offset<0
        {
            isClockwise=false
        }
        else
        {
            isClockwise=true
        }
    }
    func calcOffset(offset:CGFloat)->CGFloat
    {
        if offset <= -90
        {
            return -90
        }
        else if offset >= 90
        {
            return 90
        }
        else
        {
            return offset
        }
    }
    struct NeedleArc: Shape {
        var angle: Angle

        func path(in rect: CGRect) -> Path {
            var path = Path()
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = rect.width / 2

            let needleEnd = CGPoint(
                x: center.x + radius * cos(CGFloat(angle.radians - .pi / 2)),
                y: center.y + radius * sin(CGFloat(angle.radians - .pi / 2))
            )

            path.move(to: center)
            path.addLine(to: needleEnd)

            return path
        }
    }

}
                                                                                    
#Preview {
    @Previewable @State var offset:CGFloat = 40
    TopPart(offset: $offset)
}
struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: startAngle-Angle.degrees(90), endAngle: endAngle-Angle.degrees(90), clockwise: clockwise)

        return path
    }
}


struct Tick: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x:rect.midX, y: rect.minY) )
        path.addLine(to: CGPoint(x:rect.midX, y: rect.minY + 15))
        path.stroke(.red,lineWidth: 10)
        return path
    }
}

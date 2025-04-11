//
//  DrawingFile .swift
//  Tuner
//
//  Created by Ashish on 27/03/25.
//

import Foundation

import CoreGraphics

struct GuitarPath_{
    struct Segment
    {
        let line:CGPoint
        let curve:CGPoint
        let contorl1:CGPoint
        let contorl2:CGPoint
    }
    
    static let adjustment:CGFloat=0.085
    
    static let segements=[
        Segment(line: CGPoint(x: 0.1, y: 0.01), curve: CGPoint(x: 0.4, y: 3), contorl1: CGPoint(x: 0.99, y: 0.01),contorl2: CGPoint(x: 0.0, y: 0.25)),
        Segment(line: CGPoint(x: 0.4, y: 3), curve: CGPoint(x: 0.7, y: 3), contorl1: CGPoint(x: 0.0, y: 0.25),contorl2: CGPoint(x: 0.0, y: 0.25)),
        Segment(line: CGPoint(x: 0.7, y: 3), curve: CGPoint(x: 0.99, y: 0.01), contorl1: CGPoint(x: 0.5, y: 0.0),contorl2: CGPoint(x: 0.0, y: 0.25))

    ]
}

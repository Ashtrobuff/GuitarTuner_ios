//
//  ContentView.swift
//  Tuner
//
//  Created by Ashish on 04/03/25.
//

import SwiftUI
import SwiftData
import Accelerate
import AVFAudio
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
     @StateObject var engine=TunerEngine()
    func duplicate()
    {
        print("hello")
    }
 
    var body: some View {
        ZStack{

            GuitarBody(needlePos:$engine.difference,engine: engine)
          
    }.onAppear{
        engine.setup()
        engine.startRecording()
        
    }
    }
        
    

    }

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

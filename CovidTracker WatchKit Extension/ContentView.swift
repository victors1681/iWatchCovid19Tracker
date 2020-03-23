//
//  ContentView.swift
//  CovidTracker WatchKit Extension
//
//  Created by Victor Santos on 3/22/20.
//  Copyright © 2020 Victor Santos. All rights reserved.
//

import SwiftUI 

 

struct ContentView: View {
 
    var body: some View {
        Text("Hello, World!")
            .onAppear(){
                CovidTrackerAPI.shared.fetchState(from: .currentStates) { (states) in
                    print(states)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

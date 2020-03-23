//
//  ContentView.swift
//  CovidTracker WatchKit Extension
//
//  Created by Victor Santos on 3/22/20.
//  Copyright © 2020 Victor Santos. All rights reserved.
//

import SwiftUI 


struct ContentView: View {
  @State var counter: Int = 0
    
    var body: some View {
        Text("Total: \(counter)")
            .onAppear(){
                
                
                  CovidTrackerAPI.shared.fetchState(from: .currentStates) { (result) in
                               
                                 switch result {
                                     case .success(let states):
                                      guard let currentState = states.filter({ $0.state == "NY" }).first else { return }
                                  
                                      self.counter = currentState.positive!
                                  print(currentState)
                                     case .failure(let error):
                                         print(error.localizedDescription)
                                 }
                              }
        }
        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
              
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

//
//  ContentView.swift
//  CovidTracker WatchKit Extension
//
//  Created by Victor Santos on 3/22/20.
//  Copyright © 2020 Victor Santos. All rights reserved.
//

import SwiftUI
import YOChartImageKit

func chart() -> Image {
    
    let image = YOLineChartImage()
    image.strokeWidth = 0
    image.fillColor = .red
    image.values = [0.0, 1.0, 2.0]
    image.smooth = true
    let i = image.draw(CGRect(x: 0, y: 0, width: 140, height: 20), scale: 1)
    
    return Image(uiImage: i)
}

struct Location: Identifiable {
    let id: Int
    let country: String
    let state: String
    let town: String
}

 
struct ContentView: View {
    @State var positive = 0
    @State var state = "NY"
    @State var death = 0
    @State var negative = 0
 
    @ObservedObject var locationManager = LocationManager()
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }

    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 2){
            Text("Covid19 Tracker: \(state)")
                .font(.caption)
                .lineLimit(nil)
                .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
            Text("Cases Positive")
                .font(.footnote)
                .foregroundColor(.gray)
            Text("\(positive)")
                .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
            Text("Death")
                .font(.footnote)
                .foregroundColor(.gray)
            Text("\(death)")
                .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
            Text("Total")
                .font(.footnote)
                .foregroundColor(.gray)
            Text("\(negative)")
                .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
            HStack {
                           Text("latitude: \(userLatitude)")
                           Text("longitude: \(userLongitude)")
                       }
            chart()
        }.padding()
        .onAppear() {
             self.updateUI()
        }
    }
     
    func updateUI() {
        CovidTrackerAPI.shared.fetchState(from: .currentStates) { (result) in
            
            switch result {
            case .success(let states):
                guard let currentState = states.filter({ $0.state == self.state }).first else { return }
                
                guard let positive = currentState.positive,
                    let death = currentState.death,
                    let negative = currentState.negative
                    else{ return }
                self.positive = positive
                self.death = death
                self.negative = negative
                //print(currentState)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

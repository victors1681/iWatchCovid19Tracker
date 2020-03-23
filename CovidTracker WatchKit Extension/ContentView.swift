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
    @State var death = 0
    @State var negative = 0
 
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var covidTracker = CovidTrackerAPI()
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }

    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    var stateInfo: USState? {
        return covidTracker.stateInfo
    }
    
    var usState: String {
        guard let placeMarkInfo = locationManager.plasceMark else { return "" }
       
       self.covidTracker.fetchStateApi(state: placeMarkInfo.administrativeArea ?? "")
        return placeMarkInfo.administrativeArea ?? ""
       }
    
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 2){
            Text("Covid19 Tracker: \(usState)")
                .font(.caption)
                .lineLimit(nil)
                .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
            Text("Cases Positive")
                .font(.footnote)
                .foregroundColor(.gray)
            Text("\(stateInfo?.positive ?? 0)")
                .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
            Text("Death")
                .font(.footnote)
                .foregroundColor(.gray)
            Text("\(stateInfo?.death ?? 0)")
                .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
            Text("Negative")
                .font(.footnote)
                .foregroundColor(.gray)
            Text("\(stateInfo?.negative ?? 0)")
                .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
    
            chart()
        }.padding().background(ImageViewContainer(imageURL: "https://source.unsplash.com/1600x900/?quarantine,ny").opacity(0.3))
      
    
    } 

}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

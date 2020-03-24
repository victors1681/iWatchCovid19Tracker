//
//  ContentView.swift
//  CovidTracker WatchKit Extension
//
//  Created by Victor Santos on 3/22/20.
//  Copyright © 2020 Victor Santos. All rights reserved.
//

import SwiftUI

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
    
    var usStateDialy: [StateDaily]? {
        return covidTracker.usStateDialy
    }
    
    var placeMark: CLPlacemark? {
        guard let placeMarkInfo = locationManager.plasceMark,
            let administrativeArea = placeMarkInfo.administrativeArea else { return nil }
       
       self.covidTracker.fetchStateApi(state: administrativeArea)
       self.covidTracker.fetchStateDailyApi(usState: administrativeArea)
       return placeMarkInfo
    }
    
     
    var body: some View {
        
        VStack(alignment: .leading){
              NavigationLink(destination: StateList()) {
            VStack(alignment: .leading){
            Text("Country")
                .font(.footnote)
                .foregroundColor(.gray)
                Text("\(placeMark?.country ?? "")  \(placeMark?.administrativeArea ?? "")")
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
                Spacer()
            }   .navigationBarBackButtonHidden(true)
            }
        }.padding()
            .frame(width: nil)
            .overlay(Graph().chart(states: usStateDialy), alignment: .bottomTrailing)
            .background(
                ImageViewContainer(imageURL: "https://source.unsplash.com/1600x900/?quarantine,\(placeMark?.administrativeArea ?? "NY")")
                .opacity(0.3)
                .aspectRatio(contentMode: .fit))

            .frame(minWidth: 20, maxWidth: .infinity, minHeight: 20, maxHeight: .infinity, alignment: .topLeading)
        
       .navigationBarTitle("Covid19 Tracker")
    
    }

}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

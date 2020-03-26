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
    @State var isViewloaded = false
    
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
    
    var usCurrent: USCurrent? {
        return covidTracker.usCurrent
    }
    
    
    var placeMark: CLPlacemark? {
        guard let placeMarkInfo = locationManager.plasceMark,
            let administrativeArea = placeMarkInfo.administrativeArea else { return nil }
      
        self.covidTracker.fetchStateApi(state: administrativeArea)
        self.covidTracker.fetchStateDailyApi(usState: administrativeArea)
        return placeMarkInfo
    }
    
    
    var body: some View {
        
        ScrollView{
            VStack(alignment: .leading){
                VStack(alignment: .leading){
                    Text("Country")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("\(placeMark?.country ?? "No Country Located")  \(placeMark?.administrativeArea ?? "")")
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
                    Text("Hospitalized")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("\(stateInfo?.hospitalized ?? 0)")
                        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                    Text("US Total")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    HStack() {
                        Image(systemName: "person.2")
                        Text("\(usCurrent?.positive ?? 0)")
                            .font(.footnote)
                            .lineLimit(nil)
                            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                        Spacer()
                        Image(systemName: "waveform.path.ecg")
                            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                        Text("\(usCurrent?.hospitalized ?? 0)")
                            .font(.footnote)
                            .animation(.easeIn)
                    }.onAppear(){
                        self.covidTracker.fetchUSCurrentApi()
                    }
                    
                    
                }.navigationBarBackButtonHidden(true)
                
            }.padding()
                .frame(width: nil)
                .background(
                    ImageViewContainer(imageURL: "https://source.unsplash.com/1600x900/?quarantine,\(placeMark?.administrativeArea ?? "NY")")
                        .opacity(0.3)
                        .aspectRatio(contentMode: .fit))
                
                .frame(minWidth: 20, maxWidth: .infinity, minHeight: 20, maxHeight: .infinity, alignment: .topLeading)
                .onTapGesture {
                    let location = self.placeMark?.administrativeArea ?? "NY"
                    self.covidTracker.fetchStateApi(state: location, forceUpdate: true)
                    self.covidTracker.fetchStateDailyApi(usState: location, forceUpdate: true)
                    print("Updating...")
            }
            .navigationBarTitle("Covid19 Tracker")
            Spacer()
            VStack{
                
                VStack{
                    
                    Graph().chart(states: usStateDialy)
                    NavigationLink(destination: GraphHistoryDetail(usStateDialy: usStateDialy)){
                        Text("\(placeMark?.administrativeArea ?? "") History")
                            .font(.footnote)
                    }
                }
                
                NavigationLink(destination: StateList(currentLocation: placeMark?.administrativeArea ?? "")) {
                    Text("All US State")
                        .font(.footnote)
                }
                
                NavigationLink(destination: SourcesList(currentLocation: placeMark?.administrativeArea ?? "")) {
                    Text("Source")
                       .font(.footnote)
                }
                
                Text("\( (stateInfo?.dateChecked ?? "").toDateString())")
                    .font(.caption)
                    .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                Text("Last Update")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
            }.padding()
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

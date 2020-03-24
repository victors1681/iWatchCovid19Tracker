//
//  StateList.swift
//  CovidTracker
//
//  Created by Victor Santos on 3/23/20.
//  Copyright © 2020 Victor Santos. All rights reserved.
//

import SwiftUI

struct StateList: View {
    
    @ObservedObject var covidTracker = CovidTrackerAPI()
    var currentLocation: String?
    
    var allStates: [USState] {
        guard let list = covidTracker.stateList else { return [USState]() }
        let n = list.sorted (by: { $0.positive ?? 0 > $1.positive ?? 0 })
        return n
    }
    
    var body: some View {
        List {
            ForEach(allStates, id: \.state) { result in
                NavigationLink(destination: CountryDetail(countryData: result, currentLocation: self.currentLocation)){
                    
                    VStack(alignment: .leading){
                        
                        HStack() {
                            Image(systemName: "mappin.and.ellipse")
                            Text("\(result.state ?? "")")
                                .font(.footnote)
                            Spacer()
                        }
                        HStack() {
                            Image(systemName: "person.2")
                            Text("\(result.positive ?? 0)")
                                .font(.footnote)
                            Spacer()
                            Image(systemName: "heart.slash")
                                .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                            Text("\(result.death ?? 0)")
                                .font(.footnote)
                        }
                        HStack() {
                        Image(systemName: "calendar") 
                        Text("\((result.dateChecked ?? "").toDateString())")
                             .font(.footnote)
                        }
                    }.padding()
                }
            }
            
        }.onAppear(){
            self.covidTracker.fetchAllStateApi()
        }.navigationBarTitle("States")
    }
    
}

struct StateList_Previews: PreviewProvider {
    static var previews: some View {
        StateList()
    }
}

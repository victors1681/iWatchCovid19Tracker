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
                    Text("\(result.state ?? "") : \(result.positive ?? 0)")
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

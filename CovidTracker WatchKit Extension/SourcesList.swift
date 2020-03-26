//
//  SourcesList.swift
//  CovidTracker
//
//  Created by Victor Santos on 3/25/20.
//  Copyright © 2020 Victor Santos. All rights reserved.
//

import SwiftUI 

struct SourcesList: View {
    @ObservedObject var covidTracker = CovidTrackerAPI()
    
    var currentLocation: String?
    
    var allSources: [StateSource] {
        guard let list = covidTracker.stateSource else { return [StateSource]() }
        return list
    }
    
    var body: some View {
        List {
            
            ForEach(allSources, id: \.state) { result in
                NavigationLink(destination: SourceDetail(sourceInfo: result) ){
                VStack(alignment: .leading){
                    
                    HStack() {
                        Image(systemName: "mappin.and.ellipse")
                        Text("\(result.name ?? "")")
                            .font(.footnote)
                        Spacer()
                    }
                    HStack() {
                        Image("twitter")
                        .resizable()
                            .frame(width: 15.0, height: 15.0)
                        Text("\(result.twitter ?? "")")
                            .font(.footnote)
                    }
                    
                }.padding()
                    
                }
            }
            
        }.onAppear(){
            self.covidTracker.fetchStateSourceApi()
        }.navigationBarTitle("Sources")
            .overlay(ActivityContainer().hidden())
    }
}

struct SourcesList_Previews: PreviewProvider {
    static var previews: some View {
        SourcesList(currentLocation: "NY")
    }
}

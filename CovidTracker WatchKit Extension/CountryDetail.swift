//
//  CountryDetail.swift
//  CovidTracker
//
//  Created by Victor Santos on 3/24/20.
//  Copyright © 2020 Victor Santos. All rights reserved.
//

import SwiftUI

struct CountryDetail: View {
    
    var countryData: USState?
    var currentLocation: String?
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                
                VStack(alignment: .leading){
                    Text("Positive")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("\(countryData?.positive ?? 0)")
                        .font(.caption)
                        .lineLimit(nil)
                        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                    Text("Negative")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("\(countryData?.negative ?? 0)")
                        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                    Text("Hospitalized")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("\(countryData?.hospitalized ?? 0)")
                        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                    Text("Death")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("\(countryData?.death ?? 0)")
                        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                    Text("Total")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("\(countryData?.total ?? 0)")
                        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                    
                }
                VStack(alignment: .leading){
                    Text("Last Update")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("\( (countryData?.dateChecked ?? "").toDateString())")
                        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                }
            }
            
        }.background(
            ImageViewContainer(imageURL: "https://source.unsplash.com/1600x900/?quarantine,\(currentLocation ?? "NY")")
                .opacity(0.3)
                .aspectRatio(contentMode: .fit))
            .frame(minWidth: 20, maxWidth: .infinity)
    }
}

struct CountryDetail_Previews: PreviewProvider {
    static var previews: some View {
        CountryDetail()
    }
}

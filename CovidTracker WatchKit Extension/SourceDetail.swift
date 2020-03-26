//
//  SourceDetail.swift
//  CovidTracker
//
//  Created by Victor Santos on 3/24/20.
//  Copyright © 2020 Victor Santos. All rights reserved.
//

import SwiftUI

struct SourceDetail: View {
    
    var sourceInfo: StateSource?
    @State var isLoaded = false
    @ObservedObject var covidTracker = CovidTrackerAPI()
    
    var screenShot: Screenshot {
        guard let screen = covidTracker.siteScreenShot else { return Screenshot(ETag: nil, state: nil, filename: nil, url: nil, dateChecked: nil, size: nil)}
        return screen
    }
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                
                VStack(alignment: .leading){
                    ImageViewContainer(imageURL: screenShot.url ?? "", height: 500.0, isLoadingEnabled: true )
                        .opacity(1)
                        .aspectRatio(contentMode: .fill)
                        .onReceive(covidTracker.didScreenshotUpdate) { result in
                            self.isLoaded = true
                    }
                    
                    
                } .frame(minWidth: 20, maxWidth: .infinity)
                    .overlay(ActivityContainer().hidden())
                    .onAppear() {
                        guard let info = self.sourceInfo else { return }
                        self.covidTracker.fetchScreenShotApi(state: info.state ?? "")
                }.navigationBarTitle("Screenshot")
                    .padding()
                
                VStack(alignment: .leading){
                     VStack(alignment: .leading){
                    Text("State")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("\(sourceInfo?.name ?? "")")
                        .font(.caption)
                        .lineLimit(nil)
                        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                    Text("Note")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("\(sourceInfo?.notes ?? "")")
                        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                        .font(.footnote)
                    
                    Text("Twitter")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("\(sourceInfo?.twitter ?? "")")
                        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                        .font(.footnote)
                    Text("WebSite")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("\(sourceInfo?.covid19Site ?? "")")
                        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                        .font(.footnote)
                    Text("Date Updated")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("\((screenShot.dateChecked ?? "").toDateString())")
                        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                        .font(.footnote)
                    }.padding()
                }.background(Color.black)
                    .padding()
                    .opacity(0.8)
            }.padding()
        }
    }
}

struct SourceDetail_Previews: PreviewProvider {
    static var previews: some View {
        SourceDetail()
    }
}

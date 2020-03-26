//
//  GraphHistoryDetail.swift
//  CovidTracker
//
//  Created by Victor Santos on 3/24/20.
//  Copyright © 2020 Victor Santos. All rights reserved.
//

import SwiftUI

struct GraphHistoryDetail: View {
    var usStateDialy: [StateDaily]?
    
    var overlay: some View {
        VStack {
            if( usStateDialy?.count ?? 0 > 0){
                ActivityContainer().hidden()
            }else {
                ActivityContainer()
            }
        }
    }
    
    var body: some View {
        List{
            ForEach(usStateDialy ?? [StateDaily]() , id: \.date) { result in
                VStack(alignment: .leading){
                    Text("\((result.date ?? 0).toDateString())")
                        .font(.caption)
                        .foregroundColor(.gray)
                    HStack() {
                        Image(systemName: "person.2")
                        Text("\(result.positive ?? 0)")
                            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                        Spacer()
                        Image(systemName: "heart.slash")
                            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                        Text("\(result.death ?? 0)")
                            .animation(.easeIn)
                    }
                }.padding()
            }
        }
    }
}

struct GraphHistoryDetail_Previews: PreviewProvider {
    static var previews: some View {
        GraphHistoryDetail(usStateDialy: [StateDaily]())
    }
}

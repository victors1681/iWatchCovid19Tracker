//
//  ActivityContainer.swift
//  CovidTracker
//
//  Created by Victor Santos on 3/24/20.
//  Copyright © 2020 Victor Santos. All rights reserved.
//

import SwiftUI
import Combine

struct ActivityContainer: View {
    let kPreviewBackground = Color(red: 0, green: 0, blue: 0, opacity: 0.4)

    var body: some View {
        ZStack {
            kPreviewBackground
                .edgesIgnoringSafeArea(.all)
            VStack {
                ActivityIndicator()
                    .frame(width: 50, height: 50)
            }.foregroundColor(Color.white)
        }
    }
}

struct ActivityContainer_Previews: PreviewProvider {
    static var previews: some View {
        ActivityContainer()
    }
}





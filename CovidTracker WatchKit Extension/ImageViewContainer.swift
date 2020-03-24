//
//  SwiftUIView.swift
//  CovidTracker
//
//  Created by Victor Santos on 3/23/20.
//  Copyright © 2020 Victor Santos. All rights reserved.
//

import SwiftUI
import Combine

struct ImageViewContainer: View {
    
    @ObservedObject var remoteImageURL: RemoteImageURL
     @State var image:UIImage? = nil

    init(imageURL: String){
        remoteImageURL = RemoteImageURL(imageURL: imageURL)
    }
    
    var body: some View {
        Image(uiImage: (image == nil) ? UIImage(imageLiteralResourceName: "quarantine") : image!)
        .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 250, height: 250, alignment: .center)
        .onReceive(remoteImageURL.didChange) { data in
            self.image = UIImage(data: data) ?? UIImage()
        }
    }
}
#if DEBUG
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ImageViewContainer(imageURL: "https://source.unsplash.com/1600x900/?quarantine,ny")
    }
}
#endif

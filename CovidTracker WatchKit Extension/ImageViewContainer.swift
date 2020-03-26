//
//  SwiftUIView.swift
//  CovidTracker
//
//  Created by Victor Santos on 3/23/20.
//  Copyright © 2020 Victor Santos. All rights reserved.
//

import SwiftUI
import Combine
import UIKit

struct ImageViewContainer: View {
    
    @ObservedObject var remoteImageURL: RemoteImageURL
    @State var image:UIImage? = nil
    
    @State var height:CGFloat = 250
    var isLoadingEnabled = false
    @State var loadingHeight: CGFloat = 250
    
    init(imageURL: String, height:CGFloat = 250, isLoadingEnabled: Bool = false ){
        remoteImageURL = RemoteImageURL(imageURL: imageURL)
        self.height = height
        self.isLoadingEnabled = isLoadingEnabled
    }
    
    var overlay: some View {
        VStack {
          
            if( self.image == nil && self.isLoadingEnabled){
                ActivityContainer()
            }else {
                ActivityContainer().hidden()
            }
        }
    }
    var body: some View {
        Image(uiImage: (image == nil) ? UIImage(imageLiteralResourceName: "quarantine") : image!)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 250, height: isLoadingEnabled && image == nil ? self.loadingHeight : self.height, alignment: .center)
            .onReceive(remoteImageURL.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
        }.overlay(overlay)
    }
}
#if DEBUG
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ImageViewContainer(imageURL: "https://source.unsplash.com/1600x900/?quarantine,ny")
    }
}
#endif

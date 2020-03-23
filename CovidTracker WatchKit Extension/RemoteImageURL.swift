//
//  RemoteImageURL.swift
//  CovidTracker
//
//  Created by Victor Santos on 3/23/20.
//  Copyright © 2020 Victor Santos. All rights reserved.
//

import SwiftUI
import Combine

class RemoteImageURL: ObservableObject {

    var didChange = PassthroughSubject<Data,Never>()
    
    var data = Data() {
        didSet{
            didChange.send(data)
        }
    }
    
    init(imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.data = data
            }
        }.resume()
    }
}

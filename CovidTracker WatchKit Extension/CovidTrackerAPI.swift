//
//  CovidTrackerAPI.swift
//  CovidTracker
//
//  Created by Victor Santos on 3/23/20.
//  Copyright © 2020 Victor Santos. All rights reserved.
//

import UIKit
import Combine

public enum APIServiceError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
}

public struct USState: Codable {
    
    public let state: String?
    public let positive: Int?
    public let positiveScore: Int?
    public let negativeScore: Int?
    public let negativeRegularScore: Int?
    public let commercialScore: Int?
    public let grade: String?
    public let score: Int?
    public let negative: Int?
    public let pending: Int?
    public let hospitalized: Int?
    public let death: Int?
    public let total: Int?
    public let lastUpdateEt: String?
    public let checkTimeEt: String?
    public let dateModified: String?
    public let dateChecked: String?
}

public struct StateDaily: Codable {
    public let date: Int?
    public let state: String?
    public let positive: Int?
    public let negative: Int?
    public let pending: Int?
    public let hospitalized: Int?
    public let death: Int?
    public let total: Int?
    public let dateChecked: String?
}

public struct StateInfo: Codable {
    public let state: String?
    public let covid19SiteOld: String?
    public let covid19Site: String?
    public let covid19SiteSecondary: String?
    public let twitter: String?
    public let pui: String?
    public let pum: Bool?
    public let notes: String?
    public let name: String?
}

public struct USCurrent: Codable {
    public let positive: Int?
    public let negative: Int?
    public let posNeg: Int?
    public let hospitalized: Int?
    public let death: Int?
    public let total: Int?
}

public struct Counties: Codable {
    public let state: String?
    public let county: String?
    public let covid19Site: String?
    public let dataSite: String?
    public let mainSite: String?
    public let twitter: String?
    public let pui: String?
}


class CovidTrackerAPI: ObservableObject {
    
    public static let shared = CovidTrackerAPI()
    
    public init(){}
    
    private let urlSession = URLSession.shared
    private let HOST = "covidtracking.com"
    private let baseURL = URL(string: "https://covidtracking.com")!
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    enum Endpoint: String, CaseIterable {
        case currentStates = "states"
        case stateDaily = "states/daily"
        case stateInfo = "states/info"
        case usCurrent = "us"
        case usDaily = "us/daily"
        case counties = "counties"
        case tracker = "urls"
        case screenshots = "screenshots"
    }
    
    
    
    @Published var stateInfo: USState? {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published var usStateDialy: [StateDaily]? {
        willSet{
            objectWillChange.send()
        }
    }
    
    @Published var stateList: [USState]? {
        willSet{
            objectWillChange.send()
        }
    }
    
    @Published var usCurrent: USCurrent? {
        willSet{
            objectWillChange.send()
        }
    }
    
    
    private func fetchResources<T: Decodable>(url: URL, completion: @escaping (Result<T, APIServiceError>) -> Void) {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlSession.dataTaskCustom(with: url) { (result) in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    let values = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(values))
                } catch let err {
                    print(err)
                    completion(.failure(.decodeError))
                }
            case .failure( _):
                completion(.failure(.apiError))
            }
        }.resume()
    }
    
    private func fetchState(from endpoint: Endpoint = .currentStates, result: @escaping (Result<[USState], APIServiceError>) -> Void) {
        let trackerUrl = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent(endpoint.rawValue)
        print(trackerUrl)
        fetchResources(url: trackerUrl, completion: result)
    }
    
    
    public func fetchStateApi(state: String = "NY", forceUpdate: Bool = false){
        let currentState = self.stateInfo?.state
        
        if(currentState == nil || currentState != state && state != "" || forceUpdate){
            self.fetchState(from: .currentStates) { (result) in
                
                switch result {
                case .success(let states):
                    guard let stateLocated = states.filter({ $0.state == state }).first else { return }
                    
                    if(stateLocated.state  == nil){
                        return
                    }
                    
                    self.stateInfo = stateLocated
                //print(currentState)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    public func fetchAllStateApi(){
        
        self.fetchState(from: .currentStates) { (result) in
            
            switch result {
            case .success(let states):
                self.stateList = states
            //print(currentState)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchStateDaily(from endpoint: Endpoint = .stateDaily, state: String, result: @escaping (Result<[StateDaily], APIServiceError>) -> Void) {
        
        let query = URLQueryItem(name: "state", value: state)
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = HOST
        urlComponents.path = "/api/\(endpoint.rawValue)"
        urlComponents.queryItems = [query]
        
        print(urlComponents)
        
        fetchResources(url: urlComponents.url!.absoluteURL, completion: result)
    }
    
    
    public func fetchStateDailyApi(usState: String, forceUpdate: Bool = false){
        let currentState = self.stateInfo?.state
        
        if(currentState == nil || currentState != usState || forceUpdate){
            self.fetchStateDaily(from: .stateDaily, state: usState) { (result) in
                
                switch result {
                case .success(let states):
                    self.usStateDialy = states
                    print(states)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    public func fetchStateInfo(from endpoint: Endpoint = .stateInfo, result: @escaping (Result<[StateInfo], APIServiceError>) -> Void) {
        let trackerUrl = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent(endpoint.rawValue)
        print(trackerUrl)
        fetchResources(url: trackerUrl, completion: result)
    }
    
    private func fetchUSCurrentInfo(from endpoint: Endpoint = .usCurrent, result: @escaping (Result<[USCurrent], APIServiceError>) -> Void) {
        let trackerUrl = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent(endpoint.rawValue)
        print(trackerUrl)
        fetchResources(url: trackerUrl, completion: result)
    }
    
    public func fetchUSCurrentApi () {
        self.fetchUSCurrentInfo(from: .usCurrent) { (result) in
            
            switch result {
            case .success(let states):
                self.usCurrent = states.first
            //print(currentState)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func fetchCounties(from endpoint: Endpoint = .counties, result: @escaping (Result<[Counties], APIServiceError>) -> Void) {
        let trackerUrl = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent(endpoint.rawValue)
        print(trackerUrl)
        fetchResources(url: trackerUrl, completion: result)
    }
    
}

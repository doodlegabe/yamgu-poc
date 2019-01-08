//
//  WebConnectionProvider.swift
//  yamgu-poc
//
//  Created by Gabriel Walsh on 1/7/19.
//  Copyright © 2019 Gabriel Walsh. All rights reserved.
//

import Foundation
import Moya

func getToken()-> String{
    let token = YamguPocConfig.authToken
    return token
}

let authPlugin = AccessTokenPlugin(tokenClosure: getToken)
let YamguWebServiceProvider = MoyaProvider<YamguWebProvider>(plugins: [authPlugin, NetworkLoggerPlugin(verbose: true)])

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public enum YamguWebProvider {
    case citySearch(languageCode:String, query: String, lat:Double, lng: Double, radius: Int, page: Int)
}

extension YamguWebProvider: TargetType, AccessTokenAuthorizable {
    
    public var authorizationType: AuthorizationType {
        switch self {
        case .citySearch:
            return .bearer
        }
    }
    
    public var baseURL: URL{
        return URL(string:"https://api.yamgu.com")!
    }
    
    public var path: String{
        switch self {
        case .citySearch:
            return "/api/city/v1/search"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .citySearch( _, _, _, _, _, _ ):
            return .get
        }
    }
    
    public var task: Task {
        switch self{
        case .citySearch(let languageCode, let query, let lat, let lng, let radius, let page):
            return .requestParameters(parameters: ["languageCode": languageCode, "query": query, "lat": lat, "lng": lng, "radius": radius, "page": page], encoding: URLEncoding.default)
        }
    }
    
    public var validationType: ValidationType {
        switch self {
        case .citySearch( _, _, _, _, _, _):
            return .successCodes
        }
    }
    
     public var sampleData: Data {
        switch self {
            case .citySearch( _, _, _, _, _, _):
                do{
                    let cities = [City(longitude: -75.1652215,
                                       lattitude:39.9525839,
                                       code:2290,
                                       visual: "https://www.yamgu.com/Content/Images/Default/luoghi.jpg",
                                       name: "Philadelphia"),
                                  City(longitude: -74.644881,
                                       lattitude:39.2667819,
                                       code:1907,
                                       visual: "https://www.yamgu.com/Content/Images/Default/luoghi.jpg",
                                       name: "Marmora")]
                    let jsonData = try JSONEncoder().encode(cities)
                    return jsonData
                }catch{
                    print(error)
            }
                return "error".data(using: String.Encoding.utf8)!

        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
}

// MARK: - Response Handlers
extension Moya.Response {
    func mapNSArray() throws -> NSArray {
        let any = try self.mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}

//
//  ApiClient.swift
//  virtual tourist
//
//  Created by César Ferreira on 07/05/21.
//

import Moya

enum ApiClient {
    case photos(latitude: Double, longitude: Double)
}

extension ApiClient: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.flickr.com/services/rest") else { fatalError() }
        return url
    }

    var apiKey: String {
        return "f93338de989a82603cc02b283a9e3ead"
    }

    var limit: Int {
        return 20
    }


    var path: String {
        switch self {
        case .photos:
            return ""
        }
    }

    var method: Method {
        switch self {
        case .photos:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .photos(let latitude, let longitude):
            let parameters: [String: Any] = ["api_key": self.apiKey, "method": "flickr.photos.search", "lat": latitude, "lon": longitude, "per_page": limit, "format": "json", "nojsoncallback": "?", "page": Int.random(in: 1...20), "extras": "url_m", "media": "photo"]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json",
                "Accept": "application/json"]
    }
}

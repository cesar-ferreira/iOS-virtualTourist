//
//  NetworkManager.swift
//  virtual tourist
//
//  Created by César Ferreira on 07/05/21.
//

import Moya

protocol Networkable {
    var provider: MoyaProvider<ApiClient> { get }

    func getPhotos(latitude: Double, longitude: Double, completion: @escaping (Result<Response, Error>) -> ())
}

class NetworkManager: Networkable {

    let provider = MoyaProvider<ApiClient>(plugins: [NetworkLoggerPlugin()])

    func getPhotos(latitude: Double, longitude: Double, completion: @escaping (Result<Response, Error>) -> ()) {
        request(target: .photos(latitude: latitude, longitude: longitude), completion: completion)
    }
}

private extension NetworkManager {

    private func request<T: Decodable>(target: ApiClient, completion: @escaping (Result<T, Error>) -> ()) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}


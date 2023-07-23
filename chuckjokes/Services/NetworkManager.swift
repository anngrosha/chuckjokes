//
//  NetworkManager.swift
//  chuckjokes
//
//  Created by Ренат Хайруллин on 15.07.2023.
//

import Moya

protocol NetworkManagerProtocol {
    func fetchJoke(completion: @escaping (Result<JokeStruct, Error>) -> Void)
}

final class NetworkManger: NetworkManagerProtocol {

    private var provider = MoyaProvider<APITarget>()

    func fetchJoke(completion: @escaping (Result<JokeStruct, Error>) -> Void) {
        request(target: .getJoke, completion: completion)
    }
}

private extension NetworkManger {

    func request<T:Decodable>(target: APITarget, completion: @escaping (Result<T, Error>) -> Void) {
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

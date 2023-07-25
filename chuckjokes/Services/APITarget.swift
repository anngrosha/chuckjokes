//
//  APITarget.swift
//  chuckjokes
//
//  Created by Ренат Хайруллин on 15.07.2023.
//

import Moya

enum APITarget {
    case getJoke
    case getJokeCategory(category: String)
    case getCategories
}

extension APITarget: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://api.chucknorris.io/jokes") else {
            fatalError("Не можем получить юрл")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getJoke:
            return "/random"
        case .getJokeCategory:
            return "/random"
        case .getCategories:
            return "/categories"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .getJoke:
            return .requestParameters(parameters: [
                :
            ], encoding: URLEncoding.default)
        case let .getJokeCategory(category):
            return .requestParameters(parameters: [
                "category" : category
            ], encoding: URLEncoding.default)
        case .getCategories:
            return .requestParameters(parameters: [
                :
            ], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
            return ["Content-type": "application/json",
                    "Cache-Control" : "no-cache"]
    }
    
}




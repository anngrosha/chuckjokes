//
//  JokeResponse.swift
//  chuckjokes
//
//  Created by Ренат Хайруллин on 15.07.2023.
//

import Foundation

struct JokeStruct: Codable {
    let id: String
    let value: String
    
    
    enum CodingKeys: String, CodingKey {
        case id, value
    }
}

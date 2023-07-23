//
//  Joke+CoreDataProperties.swift
//  chuckjokes
//
//  Created by Ренат Хайруллин on 15.07.2023.
//
//

import Foundation
import CoreData


extension Joke {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Joke> {
        return NSFetchRequest<Joke>(entityName: "Joke")
    }

    @NSManaged public var jokeText: String?
    @NSManaged public var id: String?
    
    
    func setUpData(_ joke: JokeStruct) {
        self.jokeText = joke.value
        self.id = joke.id
    }

}

extension Joke : Identifiable {

}

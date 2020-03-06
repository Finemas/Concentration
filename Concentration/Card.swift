//
//  Card.swift
//  Concentration
//
//  Created by Jan Provazník on 05/03/2020.
//  Copyright © 2020 Jan Provazník. All rights reserved.
//

import Foundation

struct Card {
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqIdentifier()
    }
}

extension Card: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
     
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

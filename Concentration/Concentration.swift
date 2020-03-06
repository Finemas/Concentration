//
//  Concentration.swift
//  Concentration
//
//  Created by Jan Provazník on 05/03/2020.
//  Copyright © 2020 Jan Provazník. All rights reserved.
//

import Foundation

class Concentration {
    private(set) var cards = [Card]()
    
    private(set) var numberOfPairsOfCards: Int
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.choosecard(at: \(index)): chosen index not in the cards")
        
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // chech if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    numberOfPairsOfCards -= 1
                }
                
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberofPairsOfCards: Int) {
        assert(numberofPairsOfCards > 0, "Concentration.init(\(numberofPairsOfCards)): you must have at least one pair of cards")
        self.numberOfPairsOfCards = numberofPairsOfCards
        
        for _ in 0..<numberofPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        
        cards.shuffle()
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}

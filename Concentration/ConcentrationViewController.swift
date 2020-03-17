//
//  ViewController.swift
//  Concentration
//
//  Created by Jan Provazník on 05/03/2020.
//  Copyright © 2020 Jan Provazník. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {

//    override var vcLoggingName: String {
//        return "Game"
//    }
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    private var visibleCardButtons: [UIButton]! {
        return cardButtons?.filter { !$0.superview!.isHidden }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViewFromModel()
    }
    
    private(set) var flipCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5,
            .strokeColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ]
        
        let attributedString = NSAttributedString(
            string: traitCollection.verticalSizeClass == .compact ? "Flips\n \(flipCount)" : "Flips: \(flipCount)",
            attributes: attributes)
        
        flipCountLabel.attributedText = attributedString
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateFlipCountLabel()
    }
    
    private lazy var game = Concentration(numberofPairsOfCards: numberOfPairsOfCards)

    var numberOfPairsOfCards: Int {
        return (visibleCardButtons.count + 1) / 2
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = visibleCardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    private func updateViewFromModel() {
        if visibleCardButtons != nil {
            for index in visibleCardButtons.indices {
                let button = visibleCardButtons[index]
                let card = game.cards[index]
                
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: .normal)
                    button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                } else {
                    button.setTitle("", for: .normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) : #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
                    button.isEnabled = !card.isMatched
                }
            }
        }
    }

    private func showWinnerDialog() {
        let alert = UIAlertController(title: "You are a winner!!", message: "Won the game in \(flipCount) steps. That's a perfect score. \n Do you wanna start a new game?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "New game", style: .default, handler: { _ in
            self.resetGame()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { _ in
            // bad solution
            exit(0)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // this is a nasty solution
    private func resetGame() {
        flipCount = 0
        
        for button in visibleCardButtons {
            button.setTitle("", for: .normal)
            button.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            button.isEnabled = true
        }
        
        game = Concentration(numberofPairsOfCards: numberOfPairsOfCards)
        
        emojiChoices = theme ?? ""
    }
    
    var theme: String? {
        didSet {
            emojiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    private var emojiChoices = "🦇🧛🏻🧟😈🎃👻🍫🔪🕷👽"

    private var emoji = [Card: String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

//
//  PlayingCard.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2021/12/29.
//

import Foundation
import Algorithms


public enum Suit: String{
    case club = "c"
    case diamond = "d"
    case heart = "h"
    case spade = "s"
}

public struct PlayingCard: Equatable{
    public var suit:Suit
    public var number:Int
}

public enum HandRank: Int{
    case straightFlush = 22
    case quads = 21
    case fullHouse = 20
    case flush = 19
    case straight = 18
    case trips = 17
    case twoPair = 16
    case onePair = 15
    case highCard = 14
}

public struct Hand{
    var handRank: Int
    var handValue: Int
}


public func parseCard(card : String) -> PlayingCard?{
    if(card.utf8.count != 2){
        return nil
    }
    let number = card.prefix(1)
    var suit: Suit = Suit.spade
    switch card.suffix(1){
    case "s":
        suit = Suit.spade
    case "h":
        suit = Suit.heart
    case "d":
        suit = Suit.diamond
    case "c":
        suit = Suit.club
    default:
        return nil
    }
    var cardNumber = 0
    switch number{
    case "T":
        cardNumber = 10
    case "J":
        cardNumber = 11
    case "Q":
        cardNumber = 12
    case "K":
        cardNumber = 13
    case "A":
        cardNumber = 14
    default:
        let n = Int(number)
        if(n == nil){
            return nil
        }
        cardNumber = n!
    }
    return PlayingCard(suit: suit, number: cardNumber)
}

public func judgeHandRazzType(cards: [PlayingCard], judgeMethod: (([PlayingCard]) -> Hand), useCardNum: Int, bestlow: Bool = true) -> Hand{
    var bestHand : Hand = bestlow ? Hand(handRank: HandRank.straightFlush.rawValue + 1, handValue: 0) : Hand(handRank: 0, handValue: 0)
    for cardComb in cards.combinations(ofCount: useCardNum){
        let hand = judgeMethod(cardComb)
        if(bestlow){
            if hand.handRank < bestHand.handRank{
                bestHand.handRank = hand.handRank
                bestHand.handValue = hand.handValue
            }else if hand.handRank == bestHand.handRank{
                bestHand.handValue = min(bestHand.handValue, hand.handValue)
            }
        }else{
            if hand.handRank > bestHand.handRank{
                bestHand.handRank = hand.handRank
                bestHand.handValue = hand.handValue
            }else if hand.handRank == bestHand.handRank{
                bestHand.handValue = max(bestHand.handValue, hand.handValue)
            }
        }
    }
    return bestHand
}

public func judgeHandOmahaType(board: [PlayingCard], holeCard: [PlayingCard],
                               judgeMethod: (([PlayingCard]) -> Hand), bestlow: Bool) -> Hand{
    var bestHand : Hand = bestlow ? Hand(handRank: HandRank.straightFlush.rawValue + 1, handValue: 0) : Hand(handRank: 0, handValue: 0)
    for boardComb in board.combinations(ofCount: 3){
        for holeComb in holeCard.combinations(ofCount: 2){
            let cards = boardComb + holeComb
            let hand = judgeMethod(cards)
            if(bestlow){
                if hand.handRank < bestHand.handRank{
                    bestHand.handRank = hand.handRank
                    bestHand.handValue = hand.handValue
                }else if hand.handRank == bestHand.handRank{
                    bestHand.handValue = min(bestHand.handValue, hand.handValue)
                }
            }else{
                if hand.handRank > bestHand.handRank{
                    bestHand.handRank = hand.handRank
                    bestHand.handValue = hand.handValue
                }else if hand.handRank == bestHand.handRank{
                    bestHand.handValue = max(bestHand.handValue, hand.handValue)
                }
            }
        }
    }
    return bestHand
}

public func judgeAceToFiveLow(cards: [PlayingCard]) -> Hand{
    let rankStore = CardRankStore.shared
    let hand = rankStore.judgeRazzHand(cards: cards)
    return hand
}

public func judge27(cards: [PlayingCard]) -> Hand{
    let rankStore = CardRankStore.shared
    let hand = rankStore.judgePokerHand(cards: cards, is27: true)
    return hand
}

public func judgePokerHigh(cards: [PlayingCard]) -> Hand{
    let rankStore = CardRankStore.shared
    let hand = rankStore.judgePokerHand(cards: cards, is27: false)
    return hand
}

public func judgeBadugi(cards: [PlayingCard]) -> Hand{
    return JudgeBadugi.judgeBadugi(cards: cards, is27: false)
}

public func judgeBadugi27(cards: [PlayingCard]) -> Hand{
    return JudgeBadugi.judgeBadugi(cards: cards, is27: true)
}

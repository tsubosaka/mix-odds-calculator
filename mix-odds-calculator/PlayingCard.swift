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


private func calcHandValue(nums: [Int]) -> Int{
    var value = 0
    // 昇順に並んでいる ex nums = [2,3,5,6,8]に対して
    // 逆順にして 86532 を15進数で表した値に変換する
    // 13進数ではなく、15進数なのはA(14)まで対応するため
    for i in (0...nums.count - 1){
        value = value * 15 + nums[nums.count - 1 - i]
    }
    return value
}

private func isFlush(cards: [PlayingCard]) -> Bool{
    for i in 1...4{
        if cards[i].suit != cards[0].suit{
            return false
        }
    }
    return true
}

private func hasPair(nums: [Int]) -> Bool{
    for i in 1...nums.count - 1{
        if nums[i] == nums[i - 1]{
            return true
        }
    }
    return false
}


private func judgePairHand(nums: [Int]) -> Hand{
    var numCounts = Array(repeating: 0, count: 15)
    for n in nums{
        numCounts[n] += 1
    }
    if let quad_ind = numCounts.firstIndex(of: 4){
        let kicker_ind = numCounts.firstIndex(of: 1)
        return Hand(handRank: HandRank.quads.rawValue, handValue: quad_ind * 100 + kicker_ind!)
    }
    if let trips_ind = numCounts.firstIndex(of: 3){
        if let pair_ind = numCounts.firstIndex(of: 2){
            return Hand(handRank: HandRank.fullHouse.rawValue, handValue: trips_ind * 100 + pair_ind)
        }else{
            let kicker_ind_0 = numCounts.firstIndex(of: 1)
            let kicker_ind_1 = numCounts.lastIndex(of: 1)
            let handValue = trips_ind * 10000 + kicker_ind_1! * 100 + kicker_ind_0!
            return Hand(handRank: HandRank.trips.rawValue, handValue: handValue)
        }
    }
    let pair_ind_0 = numCounts.firstIndex(of: 2)
    let pair_ind_1 = numCounts.lastIndex(of: 2)
    if pair_ind_0! != pair_ind_1!{
        let kicker_ind = numCounts.firstIndex(of: 1)
        let handValue = pair_ind_1! * 10000 + pair_ind_0! * 100 + kicker_ind!
        return Hand(handRank: HandRank.twoPair.rawValue, handValue: handValue)
    }
    var handValue = pair_ind_0!
    for i in 0...12{
        if numCounts[14 - i] == 1{
            handValue = handValue * 100 + (14 - i)
        }
    }
    return Hand(handRank: HandRank.onePair.rawValue, handValue: handValue)
}

public func judgeHand(cards: [PlayingCard]) -> Hand{
    var numArr : [Int] = []
    for card in cards{
        numArr.append(card.number)
    }
    numArr.sort()
    if isFlush(cards: cards){
        if numArr[4] - numArr[0] == 4{
            // straight flush
            return Hand(handRank: HandRank.straightFlush.rawValue, handValue: numArr[4])
        }else{
            // flush
            return Hand(handRank: HandRank.flush.rawValue, handValue: calcHandValue(nums: numArr))
        }
    }
    // pairかどうかの判定
    if hasPair(nums: numArr){
        return judgePairHand(nums: numArr)
    }
    // straightかどうかの判定
    if numArr[4] - numArr[0] == 4{
        return Hand(handRank: HandRank.straight.rawValue, handValue: numArr[4])
    }
    return Hand(handRank: numArr[4], handValue: calcHandValue(nums: numArr))
}

public func judgeRazz(cards: [PlayingCard]) -> Hand{
    var numArr : [Int] = []
    for card in cards{
        if card.number == 14{
            numArr.append(1)
        }else{
            numArr.append(card.number)
        }
    }
    numArr.sort()
    if hasPair(nums: numArr){
        return judgePairHand(nums: numArr)
    }
    return Hand(handRank: numArr[4], handValue: calcHandValue(nums: numArr))
}

public func judgeTri(triCards: [PlayingCard]) -> Hand?{
    if(triCards[0].suit == triCards[1].suit
       || triCards[0].suit == triCards[2].suit
       || triCards[1].suit == triCards[2].suit){
        return nil
    }
    if(triCards[0].number == triCards[1].number
       || triCards[0].number == triCards[2].number
       || triCards[1].number == triCards[2].number){
        return nil
    }
    var nums: [Int] = []
    for card in triCards{
        let cardNum = card.number == 14 ? 1 : card.number
        nums.append(cardNum)
    }
    nums.sort()
    return Hand(handRank: 1, handValue: calcHandValue(nums: nums))
}

public func updateTri(bestHand: Hand?, candHand: Hand?) -> Hand?{
    if(bestHand == nil){
        return candHand
    }
    if(candHand == nil){
        return bestHand
    }
    if(bestHand!.handValue > candHand!.handValue){
        return candHand
    }
    return bestHand
}

public func judgeBadugi(cards: [PlayingCard]) -> Hand{
    var suitValueArr = Array(repeating: 0, count: 4)
    for card in cards{
        let cardNum = card.number == 14 ? 1 : card.number
        switch card.suit{
        case Suit.spade:
            suitValueArr[0] = cardNum
        case Suit.heart:
            suitValueArr[1] = cardNum
        case Suit.diamond:
            suitValueArr[2] = cardNum
        case Suit.club:
            suitValueArr[3] = cardNum
        }
    }
    suitValueArr.sort()
    if suitValueArr[0] != 0 && (!hasPair(nums: suitValueArr)){
        // Badugi
        return Hand(handRank: 0, handValue: calcHandValue(nums: suitValueArr))
    }
    // tri check
    var bestTri: Hand? = nil
    bestTri = updateTri(bestHand: bestTri, candHand: judgeTri(triCards: [cards[0], cards[1], cards[2]]))
    bestTri = updateTri(bestHand: bestTri, candHand: judgeTri(triCards: [cards[0], cards[1], cards[3]]))
    bestTri = updateTri(bestHand: bestTri, candHand: judgeTri(triCards: [cards[0], cards[2], cards[3]]))
    bestTri = updateTri(bestHand: bestTri, candHand: judgeTri(triCards: [cards[1], cards[2], cards[3]]))
    if(bestTri != nil){
        return bestTri!
    }
    var bestPair: Hand? = nil
    for i in 0...3{
        for j in 0...3{
            if(cards[i].suit == cards[j].suit){
                continue
            }
            if(cards[i].number == cards[j].number){
                continue
            }
            var ni = cards[i].number
            var nj = cards[j].number
            ni = ni == 14 ? 1 : ni
            nj = nj == 14 ? 1 : nj
            if(nj >= ni){
                continue
            }
            let handValue = calcHandValue(nums: [ni, nj])
            bestPair = updateTri(bestHand: bestPair, candHand: Hand(handRank: 2, handValue: handValue))
        }
    }
    if(bestPair != nil){
        return bestPair!
    }
    var minValue = 14
    for card in cards{
        if card.number == 14{
            minValue = 1
            break
        }
        minValue = min(minValue, card.number)
    }
    return Hand(handRank: 3, handValue: minValue)
}

public func judgeHand27(cards: [PlayingCard]) -> Hand{
    var bestHand : Hand = Hand(handRank: 23, handValue: 0)
    for cardComb in cards.combinations(ofCount: 5){
        let hand = judgeHand(cards: cardComb)
        if hand.handRank < bestHand.handRank{
            bestHand.handRank = hand.handRank
            bestHand.handValue = hand.handValue
        }else if hand.handRank == bestHand.handRank{
            bestHand.handValue = min(bestHand.handValue, hand.handValue)
        }
    }
    return bestHand
}

public func judgeHandRazz(cards: [PlayingCard]) -> Hand{
    var bestHand : Hand = Hand(handRank: 23, handValue: 0)
    for cardComb in cards.combinations(ofCount: 5){
        let hand = judgeRazz(cards: cardComb)
        if hand.handRank < bestHand.handRank{
            bestHand.handRank = hand.handRank
            bestHand.handValue = hand.handValue
        }else if hand.handRank == bestHand.handRank{
            bestHand.handValue = min(bestHand.handValue, hand.handValue)
        }
    }
    return bestHand
}

public func judgeHandBadugi(cards: [PlayingCard]) -> Hand{
    var bestHand : Hand = Hand(handRank: 23, handValue: 0)
    for cardComb in cards.combinations(ofCount: 4){
        let hand = judgeBadugi(cards: cardComb)
        if hand.handRank < bestHand.handRank{
            bestHand.handRank = hand.handRank
            bestHand.handValue = hand.handValue
        }else if hand.handRank == bestHand.handRank{
            bestHand.handValue = min(bestHand.handValue, hand.handValue)
        }
    }
    return bestHand
}

public func judgeHandRazzType(cards: [PlayingCard], judgeMethod: (([PlayingCard]) -> Hand), useCardNum: Int) -> Hand{
    var bestHand : Hand = Hand(handRank: HandRank.straightFlush.rawValue + 1, handValue: 0)
    for cardComb in cards.combinations(ofCount: useCardNum){
        let hand = judgeMethod(cardComb)
        if hand.handRank < bestHand.handRank{
            bestHand.handRank = hand.handRank
            bestHand.handValue = hand.handValue
        }else if hand.handRank == bestHand.handRank{
            bestHand.handValue = min(bestHand.handValue, hand.handValue)
        }
    }
    return bestHand
}

public func judgeHandOmahaType(board: [PlayingCard], holeCard: [PlayingCard],
                               judgeMethod: (([PlayingCard]) -> Hand), bestlow: Bool) -> Hand{
    var bestHand : Hand = bestlow ? Hand(handRank: HandRank.straightFlush.rawValue + 1, handValue: 0) : Hand(handRank: 0, handValue: 0)
    for boardComb in board.combinations(ofCount: 3){
        for holeComb in board.combinations(ofCount: 2){
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

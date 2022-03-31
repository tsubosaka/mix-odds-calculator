//
//  JudgeBadugi.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2022/04/01.
//

import Foundation

class JudgeBadugi{
    private class func calcHandValue(nums: [Int]) -> Int{
        var value = 0
        // 昇順に並んでいる ex nums = [2,3,5,6,8]に対して
        // 逆順にして 86532 を15進数で表した値に変換する
        // 13進数ではなく、15進数なのはA(14)まで対応するため
        for i in (0...nums.count - 1){
            value = value * 15 + nums[nums.count - 1 - i]
        }
        return value
    }

    private class func hasPair(nums: [Int]) -> Bool{
        for i in 1...nums.count - 1{
            if nums[i] == nums[i - 1]{
                return true
            }
        }
        return false
    }
    private class func judgeTri(triCards: [PlayingCard]) -> Hand?{
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

    private class func updateTri(bestHand: Hand?, candHand: Hand?) -> Hand?{
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
    
    class public func judgeBadugi(cards: [PlayingCard], is27: Bool) -> Hand{
        var suitValueArr = Array(repeating: 0, count: 4)
        for card in cards{
            let cardNum = card.number == 14 && !is27 ? 1 : card.number
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
        var bestTri: Hand? = nil
        bestTri = updateTri(bestHand: bestTri, candHand: judgeTri(triCards: [cards[0], cards[1], cards[2]]))
        bestTri = updateTri(bestHand: bestTri, candHand: judgeTri(triCards: [cards[0], cards[1], cards[3]]))
        bestTri = updateTri(bestHand: bestTri, candHand: judgeTri(triCards: [cards[0], cards[2], cards[3]]))
        bestTri = updateTri(bestHand: bestTri, candHand: judgeTri(triCards: [cards[1], cards[2], cards[3]]))
        if(bestTri != nil){
            return bestTri!
        }
        var bestPair: Hand? = nil
        for i in 0...2{
            for j in i + 1...3{
                if(cards[i].suit == cards[j].suit){
                    continue
                }
                if(cards[i].number == cards[j].number){
                    continue
                }
                var ni = cards[i].number
                var nj = cards[j].number
                ni = ni == 14 && !is27 ? 1 : ni
                nj = nj == 14 && !is27 ? 1 : nj
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
            if card.number == 14 && !is27{
                minValue = 1
                break
            }
            minValue = min(minValue, card.number)
        }
        return Hand(handRank: 3, handValue: minValue)
    }
}

//
//  CardRankStore.swift
//  あらかじめあり得る種類のカードの5枚の組み合わせに対する役判定を前計算しておき、
//  5枚のカードの組み合わせが与えられた時にO(1)で返すためのクラス
//
//  Created by 坪坂正志 on 2022/03/14.
//

import Foundation
import Algorithms


final public class CardRankStore{
    private var cardPrimes = [0, 0, 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41]
    private var pokerHandDictNoFlash : Dictionary<Int, Hand>
    private var pokerHandDictFlash : Dictionary<Int, Hand>
    private var pokerHandDictRazz : Dictionary<Int, Hand>

    public static let shared = CardRankStore()

    private init(){
        pokerHandDictNoFlash = [:]
        pokerHandDictFlash = [:]
        pokerHandDictRazz = [:]
        makeHandRankDict()
        makeHandRankDictRazz()
    }
    private func aceToOne(_ number: Int) -> Int{
        if(number == 14){
            return 1
        }
        return number
    }
    private func makeHandRankDictPair(handDict: inout Dictionary<Int,Hand>, isAceOne: Bool){
        // quads
        for i in 2...14{
            var quadVal = cardPrimes[i]
            quadVal = quadVal * quadVal * quadVal * quadVal
            for kicker in 2...14{
                if(i == kicker){
                    continue
                }
                let hind = quadVal * cardPrimes[kicker]
                if(isAceOne && i == 14){
                    let hv = aceToOne(i) * 100 + kicker
                    handDict[hind] = Hand(handRank: HandRank.quads.rawValue, handValue: hv)
                }else{
                    let hv = i * 100 + kicker
                    handDict[hind] = Hand(handRank: HandRank.quads.rawValue, handValue: hv)
                }
            }
        }
        // trips
        for trips_v in 2...14{
            var tripVal = cardPrimes[trips_v]
            tripVal = tripVal * tripVal * tripVal
            // full house
            for pair_v in 2...14{
                if(trips_v == pair_v){
                    continue
                }
                let pairVal = cardPrimes[pair_v] * cardPrimes[pair_v]
                let hind = tripVal * pairVal
                if(isAceOne){
                    let hv = aceToOne(trips_v) * 100 + aceToOne(pair_v)
                    handDict[hind] = Hand(handRank: HandRank.fullHouse.rawValue, handValue: hv)
                }else{
                    handDict[hind] = Hand(handRank: HandRank.fullHouse.rawValue, handValue: trips_v * 100 + pair_v)
                }
            }
            for kicker1 in 2...13{
                if(trips_v == kicker1){
                    continue
                }
                for kicker2 in kicker1 + 1...14{
                    if(trips_v == kicker2){
                        continue
                    }
                    // kicker1 < kicker2
                    let hind = tripVal * cardPrimes[kicker1] * cardPrimes[kicker2]
                    if(isAceOne){
                        let hv = aceToOne(trips_v) * 10000 + aceToOne(kicker2) * 100 + aceToOne(kicker1)
                        handDict[hind] = Hand(handRank: HandRank.trips.rawValue, handValue: hv)
                    }else{
                        handDict[hind] = Hand(handRank: HandRank.trips.rawValue, handValue: trips_v * 10000 + kicker2 * 100 + kicker1)
                    }
                }
            }
        }
        // two pair
        for pair1 in 2...14{
            for pair2 in 2...14{
                if(pair1 >= pair2){
                    continue
                }
                var pairVal = cardPrimes[pair1] * cardPrimes[pair2]
                pairVal = pairVal * pairVal
                for kicker in 2...14{
                    if(pair1 == kicker || pair2 == kicker){
                        continue
                    }
                    let hind = pairVal * cardPrimes[kicker]
                    if(isAceOne){
                        let hv = aceToOne(pair2) * 10000 + aceToOne(pair1) * 100 + aceToOne(kicker)
                        handDict[hind] = Hand(handRank: HandRank.twoPair.rawValue, handValue: hv)
                    }else{
                        handDict[hind] = Hand(handRank: HandRank.twoPair.rawValue, handValue: pair2 * 10000 + pair1 * 100 + kicker)
                    }
                }
            }
        }
        // one pair
        for pair in 2...14{
            let pairVal = cardPrimes[pair] * cardPrimes[pair]
            for kicker1 in 2...12{
                if(pair == kicker1){
                    continue
                }
                let pairVal2 = pairVal * cardPrimes[kicker1]
                for kicker2 in kicker1 + 1...13{
                    if(pair == kicker2){
                        continue
                    }
                    let pairVal3 = pairVal2 * cardPrimes[kicker2]
                    for kicker3 in kicker2 + 1...14{
                        if(pair == kicker3){
                            continue
                        }
                        let hind = pairVal3 * cardPrimes[kicker3]
                        if(isAceOne){
                            let hv = aceToOne(pair) * 1000000 + aceToOne(kicker1) * 10000 + aceToOne(kicker2) * 100 + aceToOne(kicker3)
                            handDict[hind] = Hand(handRank: HandRank.onePair.rawValue, handValue: hv)
                        }else{
                            let hv = pair * 1000000 + kicker1 * 10000 + kicker2 * 100 + kicker3
                            handDict[hind] = Hand(handRank: HandRank.onePair.rawValue, handValue: hv)
                        }
                    }
                }
            }
        }
    }
    private func makeHandRankDictRazz(){
        makeHandRankDictPair(handDict: &pokerHandDictRazz, isAceOne: true)
        let cards = [1,2,3,4,5,6,7,8,9,10,11,12,13]
        for card in cards.combinations(ofCount: 5){
            var hind = 1
            var hvalue = 0
            for i in 0...4{
                let ci = card[i]
                if(ci == 1){
                    hind *= cardPrimes[14]
                }else{
                    hind *= cardPrimes[ci]
                }
                hvalue = card[4 - i] + hvalue * 20
            }
            pokerHandDictRazz[hind] = Hand(handRank: card[4], handValue: hvalue)
        }
    }

    private func makeHandRankDict(){
        makeHandRankDictPair(handDict: &pokerHandDictNoFlash, isAceOne: false)
        // straight
        for high in 5...14{
            var hv = 1
            for i in high - 4 ... high{
                if( i == 1){
                    hv *= cardPrimes[14]
                }else{
                    hv *= cardPrimes[i]
                }
            }
            pokerHandDictNoFlash[hv] = Hand(handRank: HandRank.straight.rawValue, handValue: high)
            pokerHandDictFlash[hv] = Hand(handRank: HandRank.straightFlush.rawValue, handValue: high)
        }
        let cards = [2,3,4,5,6,7,8,9,10,11,12,13,14]
        for card in cards.combinations(ofCount: 5){
            var hv = 1
            var hvalue = 0
            for i in 0...4{
                let ci = card[i]
                hv *= cardPrimes[ci]
                hvalue = card[4 - i] + hvalue * 20
            }
            if(pokerHandDictNoFlash[hv] != nil){
                continue
            }
            pokerHandDictNoFlash[hv] = Hand(handRank: HandRank.highCard.rawValue, handValue: hvalue)
            pokerHandDictFlash[hv] = Hand(handRank: HandRank.flush.rawValue, handValue: hvalue)
        }
    }
    
    public func judgePokerHand(cards: [PlayingCard], is27: Bool) -> Hand{
        let c0 = cards[0]
        var isFlash = true
        var hv = cardPrimes[c0.number]
        for i in 1...4{
            if(cards[i].suit.rawValue != c0.suit.rawValue){
                isFlash = false
            }
            hv *= cardPrimes[cards[i].number]
        }
        // 27ではA2345はストレートではないのでこれだけ特別処理を行う
        // 8610 = 2 * 3 * 5 * 7 * 41 // A2345
        // 2281662 = 20^4 * 14 + 20^3 * 5 + 20^2 * 4 + 20 * 3 + 2
        if(hv == 8610 && is27){
            let hvalue = 2281662
            if(isFlash){
                return Hand(handRank: HandRank.flush.rawValue, handValue: hvalue)
            }else{
                return Hand(handRank: HandRank.highCard.rawValue, handValue: hvalue)
            }
        }
        if(pokerHandDictNoFlash[hv] == nil){
            return Hand(handRank: 0, handValue: 0)
        }
        if(isFlash){
            return pokerHandDictFlash[hv]!
        }else{
            return pokerHandDictNoFlash[hv]!
        }
    }
    
    public func judgeRazzHand(cards: [PlayingCard]) -> Hand{
        let c0 = cards[0]
        var hv = cardPrimes[c0.number]
        for i in 1...4{
            hv *= cardPrimes[cards[i].number]
        }
        if(pokerHandDictRazz[hv] == nil){
            return Hand(handRank: 0, handValue: 0)
        }
        return pokerHandDictRazz[hv]!
    }
}

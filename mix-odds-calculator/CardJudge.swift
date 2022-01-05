//
//  CardJudge.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2022/01/05.
//

import Foundation

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

private func hasPair(nums: [Int]) -> Bool{
    for i in 1...nums.count - 1{
        if nums[i] == nums[i - 1]{
            return true
        }
    }
    return false
}

private func isFlush(cards: [PlayingCard]) -> Bool{
    for i in 1...4{
        if cards[i].suit != cards[0].suit{
            return false
        }
    }
    return true
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

public func judgeAceToFiveLow(cards: [PlayingCard]) -> Hand{
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

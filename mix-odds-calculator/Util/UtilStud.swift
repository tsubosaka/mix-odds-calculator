//
//  UtilStud.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2022/03/31.
//

import Foundation

class UtilStud{
    private class func judgeHighHand(hand1: Hand, hand2: Hand) -> Int{
        if hand1.handRank < hand2.handRank{
            return -1
        }else if hand1.handRank > hand2.handRank{
            return 1
        }else{
            if hand1.handValue < hand2.handValue{
                return -1
            }else if hand1.handValue > hand2.handValue{
                return 1
            }else{
                return 0
            }
        }
    }
    private class func judgeLowHand(hand1: Hand, hand2: Hand) -> Int{
        return -judgeHighHand(hand1: hand1, hand2: hand2)
    }
    private class func judgeWinner(win_first: Int, win_second: Int) -> Int{
        if(win_second == -1){
            return 4
        }
        if(win_first >= 0){
            return 2 * (1 - win_first) + 4 * (1 - win_second) + 1
        }else{
            return 4 * (1 - win_second) + 2
        }
    }

    class func judgeRazz(player1_cards: [PlayingCard], player2_cards: [PlayingCard], player3_cards: [PlayingCard]) -> Int{
        let player1_hand_low : Hand = judgeHandRazzType(cards: player1_cards, judgeMethod: judgeAceToFiveLow, useCardNum: 5, bestlow: true)
        let player2_hand_low : Hand = judgeHandRazzType(cards: player2_cards, judgeMethod: judgeAceToFiveLow, useCardNum: 5, bestlow: true)
        let value_low = judgeLowHand(hand1: player1_hand_low, hand2: player2_hand_low)
        if(player3_cards.count == 0){
            if(value_low == 1){
                return 1
            }else if(value_low == -1){
                return 2
            }else{
                return 3
            }
        }
        let player3_hand_low : Hand = judgeHandRazzType(cards: player3_cards, judgeMethod: judgeAceToFiveLow, useCardNum: 5, bestlow: true)
        let value_low2 = value_low >= 0 ? judgeLowHand(hand1: player1_hand_low, hand2: player3_hand_low) :
                                          judgeLowHand(hand1: player2_hand_low, hand2: player3_hand_low)
        return judgeWinner(win_first: value_low, win_second: value_low2)
    }
    class func judge27Razz(player1_cards: [PlayingCard], player2_cards: [PlayingCard], player3_cards: [PlayingCard]) -> Int{
        let player1_hand_low : Hand = judgeHandRazzType(cards: player1_cards, judgeMethod: judge27, useCardNum: 5, bestlow: true)
        let player2_hand_low : Hand = judgeHandRazzType(cards: player2_cards, judgeMethod: judge27, useCardNum: 5, bestlow: true)
        let value_low = judgeLowHand(hand1: player1_hand_low, hand2: player2_hand_low)
        if(player3_cards.count == 0){
            if(value_low == 1){
                return 1
            }else if(value_low == -1){
                return 2
            }else{
                return 3
            }
        }
        let player3_hand_low : Hand = judgeHandRazzType(cards: player3_cards, judgeMethod: judge27, useCardNum: 5, bestlow: true)
        let value_low2 = value_low >= 0 ? judgeLowHand(hand1: player1_hand_low, hand2: player3_hand_low) :
                                          judgeLowHand(hand1: player2_hand_low, hand2: player3_hand_low)
        return judgeWinner(win_first: value_low, win_second: value_low2)
    }
    class func judgeStudHigh(player1_cards: [PlayingCard], player2_cards: [PlayingCard], player3_cards: [PlayingCard]) -> Int{
        let player1_hand_high : Hand = judgeHandRazzType(cards: player1_cards, judgeMethod: judgePokerHigh, useCardNum: 5, bestlow: false)
        let player2_hand_high : Hand = judgeHandRazzType(cards: player2_cards, judgeMethod: judgePokerHigh, useCardNum: 5, bestlow: false)
        let value_high = judgeHighHand(hand1: player1_hand_high, hand2: player2_hand_high)
        if(player3_cards.count == 0){
            if(value_high == 1){
                return 1
            }else if(value_high == -1){
                return 2
            }else{
                return 3
            }
        }
        let player3_hand_high : Hand = judgeHandRazzType(cards: player3_cards, judgeMethod: judgePokerHigh, useCardNum: 5, bestlow: false)
        let value_high2 = value_high >= 0 ? judgeHighHand(hand1: player1_hand_high, hand2: player3_hand_high) :
                                          judgeHighHand(hand1: player2_hand_high, hand2: player3_hand_high)
        return judgeWinner(win_first: value_high, win_second: value_high2)
    }
}

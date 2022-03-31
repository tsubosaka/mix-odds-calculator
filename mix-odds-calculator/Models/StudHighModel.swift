//
//  StudHighModel.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2022/03/31.
//

import Foundation

public class StudHighModel: StudModel {
    override init(){
        super.init()
        isSplitGame = false
        gameName = "Seven Card Stud Hi"
        highName = "Hi"
    }
    private func judgeHighHand(hand1: Hand, hand2: Hand) -> Int{
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
    private func judgeWinner(win_first: Int, win_second: Int) -> Int{
        if(win_second == -1){
            return 4
        }
        if(win_first >= 0){
            return 2 * (1 - win_first) + 4 * (1 - win_second) + 1
        }else{
            return 4 * (1 - win_second) + 2
        }
    }

    override func judgeHigh(player1_cards: [PlayingCard], player2_cards: [PlayingCard], player3_cards: [PlayingCard]) -> Int{
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

//
//  DeuceSevenRazzModel.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2021/12/28.
//

import Foundation
import SwiftUI

public class DeuceSevenRazzModel: StudModel {
    override init(){
        super.init()
        isSplitGame = false
        gameName = "Deuce Seven Razz"
        highName = "Razz"
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
    private func judgeLowHand(hand1: Hand, hand2: Hand) -> Int{
        return -judgeHighHand(hand1: hand1, hand2: hand2)
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
}

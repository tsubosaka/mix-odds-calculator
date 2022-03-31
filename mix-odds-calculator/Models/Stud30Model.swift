//
//  Stud30Model.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2022/01/10.
//

import Foundation


public class Stud30Model: StudModel {
    override init(){
        super.init()
        isSplitGame = true
        gameName = "Stud 30"
        highName = "Hi"
        lowName = "30"
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
    private func to30Num(num: Int) -> Int{
        if(num == 14){
            return 1
        }
        if(num >= 11){
            return 0
        }
        return num
    }
    private func calcValue30(_ player_cards: [PlayingCard]) -> Int{
        let result =
        to30Num(num: player_cards[0].number) + to30Num(num: player_cards[1].number) + to30Num(num: player_cards[6].number)
        return result
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
    
    override func judgeLow(player1_cards: [PlayingCard], player2_cards: [PlayingCard], player3_cards: [PlayingCard]) -> Int{
        let player1_hand_30 : Int = calcValue30(player1_cards)
        let player2_hand_30 : Int = calcValue30(player2_cards)
        if(player3_cards.count == 0){
            if(player1_hand_30 > player2_hand_30){
                return 1
            }else if(player1_hand_30 < player2_hand_30){
                return 2
            }else{
                return 3
            }
        }
        let player3_hand_30 : Int = calcValue30(player3_cards)
        let arr = [player1_hand_30, player2_hand_30, player3_hand_30]
        let max30 = max(player1_hand_30, player2_hand_30, player3_hand_30)
        var result = 0
        for i in 0...2{
            if(arr[i] == max30){
                result += 1 << i
            }
        }
        return result
    }
}

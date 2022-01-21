//
//  Stud30Model.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2022/01/10.
//

import Foundation


public class Stud30Model: StudTypeModel {
    @Published var win1_high = 0
    @Published var win1_30 = 0
    @Published var win2_high = 0
    @Published var win2_30 = 0
    @Published var tie1_high = 0
    @Published var tie1_30 = 0
    @Published var exp_player1 = 0.0
    private var win_player_1_high = 0
    private var win_player_1_30 = 0
    private var win_player_2_high = 0
    private var win_player_2_30 = 0
    private var tie_player_1_high = 0
    private var tie_player_1_30 = 0
    private var tie_player_2_high = 0
    private var tie_player_2_30 = 0

    private func judge(hand1: Hand, hand2: Hand) -> Int{
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
    override func initSimulation(){
        win_player_1_high = 0
        win_player_1_30 = 0
        win_player_2_high = 0
        win_player_2_30 = 0
        tie_player_1_high = 0
        tie_player_1_30 = 0
        tie_player_2_high = 0
        tie_player_2_30 = 0
    }
    func to30Num(num: Int) -> Int{
        if(num == 14){
            return 1
        }
        if(num >= 11){
            return 0
        }
        return num
    }
    func calcValue30(player_cards: [PlayingCard]) -> Int{
        let result =
        to30Num(num: player_cards[0].number) + to30Num(num: player_cards[1].number) + to30Num(num: player_cards[6].number)
        return result
    }
    
    override func judgeResult(player1_cards: [PlayingCard], player2_cards: [PlayingCard]){
        let player1_hand_high : Hand = judgeHandRazzType(cards: player1_cards, judgeMethod: judgePokerHigh, useCardNum: 5, bestlow: false)
        let player2_hand_high : Hand = judgeHandRazzType(cards: player2_cards, judgeMethod: judgePokerHigh, useCardNum: 5, bestlow: false)
        let value_high = judge(hand1: player1_hand_high, hand2: player2_hand_high)
        if value_high == 1{
            win_player_1_high += 1
        }else if value_high == -1{
            win_player_2_high += 1
        }else{
            tie_player_1_high += 1
            tie_player_2_high += 1
        }
        let player1_30 = calcValue30(player_cards: player1_cards)
        let player2_30 = calcValue30(player_cards: player2_cards)
        if player1_30 > player2_30{
            win_player_1_30 += 1
        }else if player1_30 < player2_30{
            win_player_2_30 += 1
        }else{
            tie_player_1_30 += 1
            tie_player_2_30 += 1
        }
    }
    override func updateResult(){
        win1_high = win_player_1_high
        win2_high = win_player_2_high
        win1_30 = win_player_1_30
        win2_30 = win_player_2_30
        tie1_high = tie_player_1_high
        tie1_30 = tie_player_1_30
        let exp_value = Double(win1_high - win2_high + win1_30 - win2_30) / Double(simulationNum * 2)
        exp_player1 = exp_value
    }
}

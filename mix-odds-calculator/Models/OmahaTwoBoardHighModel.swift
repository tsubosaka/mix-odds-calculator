//
//  OmahaTwoBoardHighModel.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2022/01/13.
//

import Foundation
import SwiftUI

public class OmahaTwoBoardModelHigh: OmahaTwoBoardModel {
    @Published var win1_high_1 = 0
    @Published var win2_high_1 = 0
    @Published var win1_high_2 = 0
    @Published var win2_high_2 = 0
    @Published var tie1_high_1 = 0
    @Published var tie2_high_1 = 0
    @Published var tie1_high_2 = 0
    @Published var tie2_high_2 = 0
    @Published var exp_player_1 = 0.0
    private var win1_high1_num = 0
    private var win2_high1_num = 0
    private var win1_high2_num = 0
    private var win2_high2_num = 0
    private var tie_high1_num = 0
    private var tie_high2_num = 0
    private var player1_return = 0
    private func judgeHigh(hand1: Hand, hand2: Hand) -> Int{
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
        win1_high1_num = 0
        win2_high1_num = 0
        win1_high2_num = 0
        win2_high2_num = 0
        tie_high1_num = 0
        tie_high2_num = 0
        player1_return = 0
    }
    
    override func judgeResult(player1_cards: [PlayingCard], player2_cards: [PlayingCard], board1_cards: [PlayingCard], board2_cards: [PlayingCard]){
        let hand1_high_1 = judgeHandOmahaType(board: board1_cards, holeCard: player1_cards, judgeMethod: judgePokerHigh, bestlow: false)
        let hand1_high_2 = judgeHandOmahaType(board: board2_cards, holeCard: player1_cards, judgeMethod: judgePokerHigh, bestlow: false)
        let hand2_high_1 = judgeHandOmahaType(board: board1_cards, holeCard: player2_cards, judgeMethod: judgePokerHigh, bestlow: false)
        let hand2_high_2 = judgeHandOmahaType(board: board2_cards, holeCard: player2_cards, judgeMethod: judgePokerHigh, bestlow: false)
        let judge_high_1 = judgeHigh(hand1: hand1_high_1, hand2: hand2_high_1)
        let judge_high_2 = judgeHigh(hand1: hand1_high_2, hand2: hand2_high_2)
        if judge_high_1 == 1{
            win1_high1_num += 1
        }else if judge_high_1 == -1{
            win2_high1_num += 1
        }else{
            tie_high1_num += 1
        }
        if judge_high_2 == 1{
            win1_high2_num += 1
        }else if judge_high_2 == -1{
            win2_high2_num += 1
        }else{
            tie_high2_num += 1
        }
    }
    override func updateResult(){
        win1_high_1 = win1_high1_num
        win2_high_1 = win2_high1_num
        tie1_high_1 = tie_high1_num
        tie2_high_1 = tie_high2_num
        win1_high_2 = win1_high2_num
        win2_high_2 = win2_high2_num
        tie1_high_2 = tie_high2_num
        tie2_high_2 = tie_high2_num
        exp_player_1 = Double(win1_high_1 - win2_high_1 + win1_high_2 - win2_high_2) / Double(simulationNum * 2)
    }

}

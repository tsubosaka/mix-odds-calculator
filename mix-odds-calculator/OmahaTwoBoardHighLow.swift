//
//  OmahaTwoBoardHighLow.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2022/01/05.
//

import Foundation
import SwiftUI

public class OmahaTwoBoardModelHighLow: OmahaTwoBoardModel {
    @Published var win1_high = 0
    @Published var win2_high = 0
    @Published var win1_low = 0
    @Published var win2_low = 0
    @Published var tie1_high = 0
    @Published var tie2_high = 0
    @Published var tie1_low = 0
    @Published var tie2_low = 0
    @Published var low_appear = 0
    @Published var exp_player_1 = 0.0
    private var appear_low_num = 0
    private var win1_high_num = 0
    private var win2_high_num = 0
    private var tie_high_num = 0
    private var win1_low_num = 0
    private var win2_low_num = 0
    private var tie_low_num = 0
    private var player1_return = 0
    private func bestHigh(hand1: Hand, hand2: Hand) -> Hand{
        if hand1.handRank < hand2.handRank{
            return hand2
        }else if hand1.handRank > hand2.handRank{
            return hand1
        }else{
            if hand1.handValue < hand2.handValue{
                return hand2
            }else if hand1.handValue > hand2.handValue{
                return hand1
            }else{
                return hand1
            }
        }
    }
    private func bestLow(hand1: Hand, hand2: Hand) -> Hand{
        if hand1.handRank > hand2.handRank{
            return hand2
        }else if hand1.handRank < hand2.handRank{
            return hand1
        }else{
            if hand1.handValue > hand2.handValue{
                return hand2
            }else if hand1.handValue < hand2.handValue{
                return hand1
            }else{
                return hand1
            }
        }
    }
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
    private func judgeLow(hand1: Hand, hand2: Hand) -> Int{
        return (-1) * judgeHigh(hand1: hand1, hand2: hand2)
    }

    override func initSimulation(){
        win1_high_num = 0
        win2_high_num = 0
        win1_low_num = 0
        win2_low_num = 0
        tie_high_num = 0
        tie_low_num = 0
        appear_low_num = 0
        player1_return = 0
    }
    override func judgeResult(player1_cards: [PlayingCard], player2_cards: [PlayingCard], board1_cards: [PlayingCard], board2_cards: [PlayingCard]){
        let hand1_high_1 = judgeHandOmahaType(board: board1_cards, holeCard: player1_cards, judgeMethod: judgePokerHigh, bestlow: false)
        let hand1_high_2 = judgeHandOmahaType(board: board2_cards, holeCard: player1_cards, judgeMethod: judgePokerHigh, bestlow: false)
        let hand1_high = bestHigh(hand1: hand1_high_1, hand2: hand1_high_2)
        let hand2_high_1 = judgeHandOmahaType(board: board1_cards, holeCard: player2_cards, judgeMethod: judgePokerHigh, bestlow: false)
        let hand2_high_2 = judgeHandOmahaType(board: board2_cards, holeCard: player2_cards, judgeMethod: judgePokerHigh, bestlow: false)
        let hand2_high = bestHigh(hand1: hand2_high_1, hand2: hand2_high_2)
        let judge_high = judgeHigh(hand1: hand1_high, hand2: hand2_high)
        if judge_high == 1{
            win1_high_num += 1
        }else if judge_high == -1{
            win2_high_num += 1
        }else{
            tie_high_num += 1
        }
        let hand1_low_1 = judgeHandOmahaType(board: board1_cards, holeCard: player1_cards, judgeMethod: judgeAceToFiveLow, bestlow: true)
        let hand1_low_2 = judgeHandOmahaType(board: board2_cards, holeCard: player1_cards, judgeMethod: judgeAceToFiveLow, bestlow: true)
        let hand1_low = bestLow(hand1: hand1_low_1, hand2: hand1_low_2)
        let hand2_low_1 = judgeHandOmahaType(board: board1_cards, holeCard: player2_cards, judgeMethod: judgeAceToFiveLow, bestlow: true)
        let hand2_low_2 = judgeHandOmahaType(board: board2_cards, holeCard: player2_cards, judgeMethod: judgeAceToFiveLow, bestlow: true)
        let hand2_low = bestLow(hand1: hand2_low_1, hand2: hand2_low_2)
        if(hand1_low.handRank <= 8 || hand2_low.handRank <= 8){
            appear_low_num += 1
            //low should be 8 or better
            let judge_low = judgeLow(hand1: hand1_low, hand2: hand2_low)
            if judge_low == 1{
                win1_low_num += 1
                player1_return += 1
            }else if judge_low == -1{
                win2_low_num += 1
                player1_return -= 1
            }else{
                tie_low_num += 1
            }
            if judge_high == 1{
                player1_return += 1
            }else if judge_high == -1{
                player1_return -= 1
            }
        }else{
            if judge_high == 1{
                player1_return += 2
            }else if judge_high == -1{
                player1_return -= 2
            }
        }
    }
    override func updateResult(){
        win1_high = win1_high_num
        win2_high = win2_high_num
        tie1_high = tie_high_num
        tie2_high = tie_high_num
        win1_low = win1_low_num
        win2_low = win2_low_num
        low_appear = appear_low_num
        tie1_low = tie_low_num
        tie2_low = tie_low_num
        exp_player_1 = Double(player1_return) / Double(simulationNum * 2)
    }

}

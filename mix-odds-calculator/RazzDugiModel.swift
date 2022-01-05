//
//  RazzDugiModel.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2022/01/03.
//

import Foundation
import SwiftUI
import Algorithms

public class RazzDugiModel: StudTypeModel {
    @Published var win1_razz = 0
    @Published var win1_badugi = 0
    @Published var win2_razz = 0
    @Published var win2_badugi = 0
    @Published var tie1_badugi = 0
    @Published var tie1_razz = 0
    @Published var exp_player1 = 0.0
    private var win_player_1_razz = 0
    private var win_player_1_badugi = 0
    private var win_player_2_razz = 0
    private var win_player_2_badugi = 0
    private var tie_player_1_razz = 0
    private var tie_player_1_badugi = 0
    private var tie_player_2_razz = 0
    private var tie_player_2_badugi = 0

    private func judge(hand1: Hand, hand2: Hand) -> Int{
        if hand1.handRank < hand2.handRank{
            return 1
        }else if hand1.handRank > hand2.handRank{
            return -1
        }else{
            if hand1.handValue < hand2.handValue{
                return 1
            }else if hand1.handValue > hand2.handValue{
                return -1
            }else{
                return 0
            }
        }
    }
    override func initSimulation(){
        win_player_1_razz = 0
        win_player_1_badugi = 0
        win_player_2_razz = 0
        win_player_2_badugi = 0
        tie_player_1_razz = 0
        tie_player_1_badugi = 0
        tie_player_2_razz = 0
        tie_player_2_badugi = 0
    }
    
    override func judgeResult(player1_cards: [PlayingCard], player2_cards: [PlayingCard]){
        let player1_hand_razz : Hand = judgeHandRazzType(cards: player1_cards, judgeMethod: judgeAceToFiveLow, useCardNum: 5)
        let player2_hand_razz : Hand = judgeHandRazzType(cards: player2_cards, judgeMethod: judgeAceToFiveLow, useCardNum: 5)
        let value_razz = judge(hand1: player1_hand_razz, hand2: player2_hand_razz)
        if value_razz == 1{
            win_player_1_razz += 1
        }else if value_razz == -1{
            win_player_2_razz += 1
        }else{
            tie_player_1_razz += 1
            tie_player_2_razz += 1
        }
        let player1_hand_badugi : Hand = judgeHandRazzType(cards: player1_cards, judgeMethod: judgeBadugi, useCardNum: 4)
        let player2_hand_badugi : Hand = judgeHandRazzType(cards: player2_cards, judgeMethod: judgeBadugi, useCardNum: 4)
        let value_badugi = judge(hand1: player1_hand_badugi, hand2: player2_hand_badugi)
        if value_badugi == 1{
            win_player_1_badugi += 1
        }else if value_badugi == -1{
            win_player_2_badugi += 1
        }else{
            tie_player_1_badugi += 1
            tie_player_2_badugi += 1
        }
    }
    override func updateResult(){
        win1_razz = win_player_1_razz
        win2_razz = win_player_2_razz
        win1_badugi = win_player_1_badugi
        win2_badugi = win_player_2_badugi
        tie1_badugi = tie_player_1_badugi
        tie1_razz = tie_player_1_razz
        let exp_value = Double(win1_razz - win2_razz + win1_badugi - win2_badugi) / 2000.0
        exp_player1 = exp_value
    }
}

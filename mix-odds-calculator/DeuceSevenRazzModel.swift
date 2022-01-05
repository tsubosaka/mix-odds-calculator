//
//  DeuceSevenRazzModel.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2021/12/28.
//

import Foundation
import SwiftUI

public class DeuceSevenRazzModel: StudTypeModel {
    @Published var win1 = 0
    @Published var win2 = 0
    @Published var tie12 = 0
    private var win_player_1 = 0
    private var win_player_2 = 0
    private var tie_player_1 = 0
    private var tie_player_2 = 0

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
        win_player_1 = 0
        win_player_2 = 0
        tie_player_1 = 0
        tie_player_2 = 0
    }
    override func judgeResult(player1_cards: [PlayingCard], player2_cards: [PlayingCard]){
        let player1_hand : Hand = judgeHand27(cards: player1_cards)
        let player2_hand : Hand = judgeHand27(cards: player2_cards)
        let value = judge(hand1: player1_hand, hand2: player2_hand)
        if value == 1{
            win_player_1 += 1
        }else if value == -1{
            win_player_2 += 1
        }else{
            tie_player_1 += 1
            tie_player_2 += 1
        }
    }
    override func updateResult(){
        win1 = win_player_1
        win2 = win_player_2
        tie12 = tie_player_1
    }
}

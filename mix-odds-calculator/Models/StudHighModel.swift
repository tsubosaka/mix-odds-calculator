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
        return UtilStud.judgeStudHigh(player1_cards: player1_cards, player2_cards: player2_cards, player3_cards: player3_cards)
    }
}

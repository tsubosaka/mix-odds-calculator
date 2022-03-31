//
//  RazzDeucy.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2022/04/01.
//

import Foundation

public class RazzDeucyModel: StudModel {
    override init(){
        super.init()
        isSplitGame = true
        gameName = "RazzDeucy"
        highName = "Razz"
        lowName = "Badugi"
    }
    override func judgeHigh(player1_cards: [PlayingCard], player2_cards: [PlayingCard], player3_cards: [PlayingCard]) -> Int{
        return UtilStud.judge27Razz(player1_cards: player1_cards, player2_cards: player2_cards, player3_cards: player3_cards)
    }
    override func judgeLow(player1_cards: [PlayingCard], player2_cards: [PlayingCard], player3_cards: [PlayingCard]) -> Int{
        return UtilStud.judgeStudBadugi27(player1_cards: player1_cards, player2_cards: player2_cards, player3_cards: player3_cards)
    }

}

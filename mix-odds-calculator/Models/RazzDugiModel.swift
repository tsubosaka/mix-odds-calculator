//
//  RazzDugiModel.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2022/01/03.
//

import Foundation
import SwiftUI
import Algorithms

public class RazzDugiModel: StudModel {
    override init(){
        super.init()
        isSplitGame = true
        gameName = "RazzDugi"
        highName = "Razz"
        lowName = "Badugi"
    }
    override func judgeHigh(player1_cards: [PlayingCard], player2_cards: [PlayingCard], player3_cards: [PlayingCard]) -> Int{
        return UtilStud.judgeRazz(player1_cards: player1_cards, player2_cards: player2_cards, player3_cards: player3_cards)
    }
    override func judgeLow(player1_cards: [PlayingCard], player2_cards: [PlayingCard], player3_cards: [PlayingCard]) -> Int{
        return UtilStud.judgeStudBadugi(player1_cards: player1_cards, player2_cards: player2_cards, player3_cards: player3_cards)
    }

}

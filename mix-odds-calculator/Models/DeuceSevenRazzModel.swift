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
    override func judgeHigh(player1_cards: [PlayingCard], player2_cards: [PlayingCard], player3_cards: [PlayingCard]) -> Int{
        return UtilStud.judge27Razz(player1_cards: player1_cards, player2_cards: player2_cards, player3_cards: player3_cards)
    }
}

//
//  RazzModel.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2022/03/31.
//

import Foundation
import SwiftUI

public class RazzModel: StudModel {
    override init(){
        super.init()
        isSplitGame = false
        gameName = "Razz"
        highName = "Razz"
    }
    override func judgeHigh(player1_cards: [PlayingCard], player2_cards: [PlayingCard], player3_cards: [PlayingCard]) -> Int{
        return UtilStud.judgeRazz(player1_cards: player1_cards, player2_cards: player2_cards, player3_cards: player3_cards)
    }
}

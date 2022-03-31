//
//  StudModel.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2022/03/31.
//

import Foundation
import SwiftUI

public class StudModel: ObservableObject {
    @Published var isError = false
    @Published var errorMessage = ""
    @Published var isCalculated = false
    @Published var player_hand1 = ""
    @Published var player_hand2 = ""
    @Published var player_hand3 = ""
    @Published var dead_hand = ""
    @Published var simulationNum = 0
    @Published var playerNum = 2
    @Published var elapseTime = 0.0
    @Published var isSplitGame = false
    @Published var gameName = ""
    @Published var highName = ""
    @Published var lowName = ""
    private func parsePlayingCard(playingCard: String) -> [PlayingCard]?{
        let hand_arr: [String] = playingCard.components(separatedBy: " ")
        var result: [PlayingCard] = []
        if playingCard.isEmpty{
            return result
        }
        for hstr in hand_arr {
            let c = parseCard(card: hstr)
            if(c == nil){
                isError = true
                errorMessage = hstr + "は不正な形式です"
                return nil
            }
            result.append(c!)
        }
        return result
    }
    private func getDeck() -> [PlayingCard]{
        var result: [PlayingCard] = []
        for num in 2...14{
            result.append(PlayingCard(suit: Suit.club,number: num))
            result.append(PlayingCard(suit: Suit.diamond,number: num))
            result.append(PlayingCard(suit: Suit.heart,number: num))
            result.append(PlayingCard(suit: Suit.spade,number: num))
        }
        return result
    }
    private func removeCardFromDeck(deck: inout [PlayingCard], cards: [PlayingCard])-> Bool{
        for card in cards{
            if let ind = deck.firstIndex(of: card){
                deck.remove(at: ind)
            }else{
                isError = true
                errorMessage = String(card.number) + "" + String(card.suit.rawValue) + "は重複しています"
                return false
            }
        }
        return true
    }
    public func calculateOdds(hand1: String, hand2: String, hand3: String, deadCard: String, numberOfSimulations: Int){
        isError = false
        if(hand1.isEmpty || hand2.isEmpty){
            isError = true
            errorMessage = "Player1もしくはPlayer2のハンドが空です"
            return
        }
        let hand1_arr = parsePlayingCard(playingCard: hand1)
        let hand2_arr = parsePlayingCard(playingCard: hand2)
        let hand3_arr = parsePlayingCard(playingCard: hand3)
        let dead_arr = parsePlayingCard(playingCard: deadCard)
        if(hand1_arr == nil || hand2_arr == nil || hand3_arr == nil || dead_arr == nil){
            return
        }
        if(hand1_arr!.count != hand2_arr!.count){
            isError = true
            errorMessage = "Player1とPlayer2のハンド数が異なります"
            return
        }
        if(hand3_arr!.count != 0 && (hand1_arr!.count != hand3_arr!.count)){
            isError = true
            errorMessage = "Player1とPlayer3のハンド数が異なります"
            return
        }
        var deck: [PlayingCard] = getDeck()
        if(!removeCardFromDeck(deck: &deck, cards: hand1_arr!)){
            return
        }
        if(!removeCardFromDeck(deck: &deck, cards: hand2_arr!)){
            return
        }
        if(!removeCardFromDeck(deck: &deck, cards: hand3_arr!)){
            return
        }
        if(!removeCardFromDeck(deck: &deck, cards: dead_arr!)){
            return
        }
        playerNum = 2
        if(hand3_arr!.count != 0){
            playerNum = 3
        }
        let start = Date()
        initSimultaion()
        for _ in 1...numberOfSimulations{
            deck.shuffle()
            var player1 : [PlayingCard] = hand1_arr!
            var player2 : [PlayingCard] = hand2_arr!
            var player3 : [PlayingCard] = hand3_arr!
            let leftCard = 7 - player1.count
            if leftCard != 0{
                for i in 1...leftCard{
                    player1.append(deck[i - 1])
                }
                for i in 1...leftCard{
                    player2.append(deck[i - 1 + leftCard])
                }
            }
            if(playerNum == 3){
                if leftCard != 0{
                    for i in 1...leftCard{
                        player3.append(deck[i - 1 + 2 * leftCard])
                    }
                }
            }
            let highResult = judgeHigh(player1_cards: player1, player2_cards: player2, player3_cards: player3)
            var lowResult = 0
            if(isSplitGame){
                lowResult = judgeLow(player1_cards: player1, player2_cards: player2, player3_cards: player3)
            }
            updateResult(highResult: highResult, lowResult: lowResult)
        }
        player_hand1 = hand1
        player_hand2 = hand2
        player_hand3 = hand3
        dead_hand = deadCard
        simulationNum = numberOfSimulations
        publishResult()
        let elapsed = Date().timeIntervalSince(start)
        elapseTime = elapsed
        isCalculated = true
    }
    
    private func updateWinNum(_ result: Int, _ pot : Int,
                                   _ win1: inout Int, _ win2: inout Int, _ win3: inout Int,
                                   _ tie1: inout Int, _ tie2: inout Int, _ tie3: inout Int,
                                   _ gain1: inout Int, _ gain2: inout Int, _ gain3: inout Int) {
        switch result{
        case 1:
            win1 += 1
            gain1 += pot
        case 2:
            win2 += 1
            gain2 += pot
        case 3:
            tie1 += 1
            tie2 += 1
            gain1 += pot / 2
            gain2 += pot / 2
        case 4:
            win3 += 1
            gain3 += pot
        case 5:
            tie1 += 1
            tie3 += 1
            gain1 += pot / 2
            gain3 += pot / 2
        case 6:
            tie2 += 1
            tie3 += 1
            gain2 += pot / 2
            gain3 += pot / 2
        case 7:
            tie1 += 1
            tie2 += 1
            tie3 += 1
            gain1 += pot / 3
            gain2 += pot / 3
            gain3 += pot / 3
        default:
            break
        }
    }
    
    private func updateResult(highResult : Int, lowResult : Int){
        var gain1 = 0
        var gain2 = 0
        var gain3 = 0
        if(lowResult != 0){ // low appear
            updateWinNum(lowResult, 6, &_win1_low, &_win2_low, &_win3_low, &_tie1_low, &_tie2_low, &_tie3_low, &gain1, &gain2, &gain3)
            updateWinNum(highResult, 6, &_win1_high, &_win2_high, &_win3_high, &_tie1_high, &_tie2_high, &_tie3_high, &gain1, &gain2, &gain3)
        }else{
            updateWinNum(highResult, 12, &_win1_high, &_win2_high, &_win3_high, &_tie1_high, &_tie2_high, &_tie3_high, &gain1, &gain2, &gain3)
        }
        _gain1 += gain1
        _gain2 += gain2
        _gain3 += gain3
        if(gain1 == 12){
            _scoop1 += 1
        }
        if(gain2 == 12){
            _scoop2 += 1
        }
        if(gain3 == 12){
            _scoop3 += 1
        }
    }
    func judgeHigh(player1_cards: [PlayingCard], player2_cards: [PlayingCard], player3_cards: [PlayingCard]) -> Int{
        return 0
    }
    func judgeLow(player1_cards: [PlayingCard], player2_cards: [PlayingCard], player3_cards: [PlayingCard]) -> Int{
        return 0
    }
    private func initSimultaion(){
        _win1_high = 0
        _win2_high = 0
        _win3_high = 0
        _tie1_high = 0
        _tie2_high = 0
        _tie3_high = 0
        _win1_low = 0
        _win2_low = 0
        _win3_low = 0
        _tie1_low = 0
        _tie2_low = 0
        _tie3_low = 0
        _scoop1 = 0
        _scoop2 = 0
        _scoop3 = 0
        _gain1 = 0
        _gain2 = 0
        _gain3 = 0
    }
    private func publishResult(){
        win1_h = _win1_high
        win2_h = _win2_high
        win3_h = _win3_high
        win1_l = _win1_low
        win2_l = _win2_low
        win3_l = _win3_low
        tie1_h = _tie1_high
        tie2_h = _tie2_high
        tie3_h = _tie3_high
        tie1_l = _tie1_low
        tie2_l = _tie2_low
        tie3_l = _tie3_low
        let tot_gain = Double(_gain1 + _gain2 + _gain3)
        equity1 = Double(_gain1) * 100.0 / tot_gain
        equity2 = Double(_gain2) * 100.0 / tot_gain
        equity3 = Double(_gain3) * 100.0 / tot_gain
        scoop_1 = _scoop1
        scoop_2 = _scoop2
        scoop_3 = _scoop3
    }
    @Published var win1_h = 0
    @Published var win2_h = 0
    @Published var win3_h = 0
    @Published var win1_l = 0
    @Published var win2_l = 0
    @Published var win3_l = 0
    @Published var tie1_h = 0
    @Published var tie2_h = 0
    @Published var tie3_h = 0
    @Published var tie1_l = 0
    @Published var tie2_l = 0
    @Published var tie3_l = 0
    @Published var equity1 = 0.0
    @Published var equity2 = 0.0
    @Published var equity3 = 0.0
    @Published var scoop_1 = 0
    @Published var scoop_2 = 0
    @Published var scoop_3 = 0

    private var _win1_high = 0
    private var _win1_low = 0
    private var _tie1_high = 0
    private var _tie1_low = 0
    private var _win2_high = 0
    private var _win2_low = 0
    private var _tie2_high = 0
    private var _tie2_low = 0
    private var _win3_high = 0
    private var _win3_low = 0
    private var _tie3_high = 0
    private var _tie3_low = 0
    private var _scoop1 = 0
    private var _scoop2 = 0
    private var _scoop3 = 0
    private var _gain1 = 0
    private var _gain2 = 0
    private var _gain3 = 0
}

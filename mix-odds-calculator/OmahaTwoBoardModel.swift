//
//  OmahaTwoBoardModel.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2022/01/05.
//

import Foundation
import SwiftUI

public class OmahaTwoBoardModel: ObservableObject {
    @Published var isError = false
    @Published var errorMessage = ""
    @Published var isCalculated = false
    @Published var player_card1 = ""
    @Published var player_card2 = ""
    @Published var board1 = ""
    @Published var board2 = ""
    @Published var dead_card = ""
    @Published var simulationNum = 0
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
    public func calculateOdds(hand1: String, hand2: String, board1: String, board2: String, deadCard: String, numberOfSimulations: Int){
        isError = false
        if(hand1.isEmpty || hand2.isEmpty){
            isError = true
            errorMessage = "Player1もしくはPlayer2のハンドが空です"
            return
        }
        let hand1_arr = parsePlayingCard(playingCard: hand1)
        let hand2_arr = parsePlayingCard(playingCard: hand2)
        let board1_arr = parsePlayingCard(playingCard: board1)
        let board2_arr = parsePlayingCard(playingCard: board2)
        let dead_arr = parsePlayingCard(playingCard: deadCard)
        if(hand1_arr == nil || hand2_arr == nil || board1_arr == nil || dead_arr == nil || board2_arr == nil ){
            return
        }
        if(hand1_arr!.count != hand2_arr!.count){
            isError = true
            errorMessage = "Player1とPlayer2のハンド数が異なります"
            return
        }
        if(board1_arr!.count != board2_arr!.count){
            isError = true
            errorMessage = "Board1とBoard2のハンド数が異なります"
            return
        }
        var deck: [PlayingCard] = getDeck()
        if(!removeCardFromDeck(deck: &deck, cards: hand1_arr!)){
            return
        }
        if(!removeCardFromDeck(deck: &deck, cards: hand2_arr!)){
            return
        }
        if(!removeCardFromDeck(deck: &deck, cards: board1_arr!)){
            return
        }
        if(!removeCardFromDeck(deck: &deck, cards: board2_arr!)){
            return
        }
        if(!removeCardFromDeck(deck: &deck, cards: dead_arr!)){
            return
        }
        initSimulation()
        for _ in 1...numberOfSimulations{
            deck.shuffle()
            var board1_sim : [PlayingCard] = board1_arr!
            var board2_sim : [PlayingCard] = board2_arr!
            let leftCard = 5 - board1_sim.count
            if leftCard != 0{
                for i in 1...leftCard{
                    board1_sim.append(deck[i - 1])
                }
                for i in 1...leftCard{
                    board2_sim.append(deck[i - 1 + leftCard])
                }
            }
            judgeResult(player1_cards: hand1_arr!, player2_cards: hand2_arr!, board1_cards: board1_sim, board2_cards: board2_sim)
        }
        player_card1 = hand1
        player_card2 = hand2
        self.board1 = board1
        self.board2 = board2
        dead_card = deadCard
        simulationNum = numberOfSimulations
        updateResult()
        isCalculated = true
    }
    func initSimulation(){
        
    }
    func judgeResult(player1_cards: [PlayingCard], player2_cards: [PlayingCard], board1_cards: [PlayingCard], board2_cards: [PlayingCard]){
        
    }
    func updateResult(){
        
    }
}

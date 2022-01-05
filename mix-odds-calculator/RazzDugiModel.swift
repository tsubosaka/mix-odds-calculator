//
//  RazzDugiModel.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2022/01/03.
//

import Foundation
import SwiftUI
import Algorithms

public class RazzDugiModel: ObservableObject {
    @Published var isError = false
    @Published var errorMessage = ""
    @Published var isCalculated = false
    @Published var player_hand1 = ""
    @Published var player_hand2 = ""
    @Published var dead_hand = ""
    @Published var win1_razz = 0
    @Published var win1_badugi = 0
    @Published var win2_razz = 0
    @Published var win2_badugi = 0
    @Published var tie1_badugi = 0
    @Published var tie1_razz = 0
    @Published var exp_player1 = 0.0
    private func parseHand(hand: String) -> [PlayingCard]?{
        let hand_arr: [String] = hand.components(separatedBy: " ")
        var result: [PlayingCard] = []
        if hand.isEmpty{
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
    public func calculateOdds(hand1: String, hand2: String, hand3: String, deadCard: String){
        isError = false
        if(hand1.isEmpty || hand2.isEmpty){
            isError = true
            errorMessage = "Player1もしくはPlayer2のハンドが空です"
            return
        }
        let hand1_arr = parseHand(hand: hand1)
        let hand2_arr = parseHand(hand: hand2)
        let dead_arr = parseHand(hand: deadCard)
        if(hand1_arr == nil || hand2_arr == nil){
            return
        }
        if(hand1_arr!.count != hand2_arr!.count){
            isError = true
            errorMessage = "Player1もしくはPlayer2のハンド数が異なります"
            return
        }
        var deck: [PlayingCard] = getDeck()
        for hand in hand1_arr!{
            if let ind = deck.firstIndex(of: hand){
                deck.remove(at: ind)
            }else{
                isError = true
                errorMessage = String(hand.number) + "" + String(hand.suit.rawValue) + "は重複しています"
                return
            }
        }
        for hand in hand2_arr!{
            if let ind = deck.firstIndex(of: hand){
                deck.remove(at: ind)
            }else{
                isError = true
                errorMessage = String(hand.number) + "" + String(hand.suit.rawValue) + "は重複しています"
                return
            }
        }
        for hand in dead_arr!{
            if let ind = deck.firstIndex(of: hand){
                deck.remove(at: ind)
            }else{
                isError = true
                errorMessage = String(hand.number) + "" + String(hand.suit.rawValue) + "は重複しています"
                return
            }
        }
        let simulationNum = 1000
        var player1_win_razz = 0
        var player2_win_razz = 0
        var player12_tie_razz = 0
        var player1_win_badugi = 0
        var player2_win_badugi = 0
        var player12_tie_badugi = 0
        for _ in 1...simulationNum{
            deck.shuffle()
            var player1 : [PlayingCard] = hand1_arr!
            var player2 : [PlayingCard] = hand2_arr!
            let leftCard = 7 - player1.count
            if leftCard != 0{
                for i in 1...leftCard{
                    player1.append(deck[i - 1])
                }
                for i in 1...leftCard{
                    player2.append(deck[i - 1 + leftCard])
                }
            }
            let player1_hand : Hand = judgeHandRazz(cards: player1)
            let player2_hand : Hand = judgeHandRazzType(cards: player2, judgeMethod: judgeAceToFiveLow, useCardNum: 5)
            let value = judge(hand1: player1_hand, hand2: player2_hand)
            if value == 1{
                player1_win_razz += 1
            }else if value == -1{
                player2_win_razz += 1
            }else{
                player12_tie_razz += 1
            }
            let player1_hand_badugi : Hand = judgeHandBadugi(cards: player1)
            let player2_hand_badugi : Hand = judgeHandBadugi(cards: player2)
            let value_badugi = judge(hand1: player1_hand_badugi, hand2: player2_hand_badugi)
            if value_badugi == 1{
                player1_win_badugi += 1
            }else if value_badugi == -1{
                player2_win_badugi += 1
            }else{
                player12_tie_badugi += 1
            }
        }
        isCalculated = true
        player_hand1 = hand1
        player_hand2 = hand2
        dead_hand = deadCard
        win1_razz = player1_win_razz
        win2_razz = player2_win_razz
        tie1_razz = player12_tie_razz
        win1_badugi = player1_win_badugi
        win2_badugi = player2_win_badugi
        tie1_badugi = player12_tie_badugi
        let exp_value = Double(win1_razz - win2_razz + win1_badugi - win2_badugi) / 2000.0
        exp_player1 = exp_value
    }
}

//
//  TestRankStoreView.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2022/03/30.
//

import SwiftUI

public class TestRankObject : ObservableObject{
    @Published var isError = false
    @Published var errorMessage = ""
    @Published var isCalculated = false
    @Published var handValue = 0
    @Published var handRank = 0
    @Published var handValue2 = 0
    @Published var handRank2 = 0

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
    public func calculate(hand1: String){
        isError = false
        if(hand1.isEmpty){
            isError = true
            errorMessage = "Player1もしくはPlayer2のハンドが空です"
            return
        }
        let hand1_arr = parsePlayingCard(playingCard: hand1)
        let rankStore = CardRankStore.shared
        let hand = rankStore.judgePokerHand(cards: hand1_arr!, is27: true)
        handValue = hand.handValue
        handRank = hand.handRank
        let hand2 = rankStore.judgeRazzHand(cards: hand1_arr!)
        handValue2 = hand2.handValue
        handRank2 = hand2.handRank
        isCalculated = true
    }
    
}
struct TestRankStoreView: View {
    @State private var hand1 = ""
    @ObservedObject var model  = TestRankObject()
    var body: some View {
        VStack{
            HStack{
                Text("Player1 Hand")
                Spacer()
            }
            TextField("Ad 2h 3h 4c 5s", text: $hand1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                model.calculate(hand1: hand1)
            }){
                Text("計算")
            }.alert(isPresented: $model.isError){
                Alert(title: Text("エラー"), message: Text(model.errorMessage),
                      dismissButton: .default(Text("OK")))
            }
            if(model.isCalculated){
                Text("rank: " + String(model.handRank))
                Text("value: " + String(model.handValue))
                Text("rank2: " + String(model.handRank2))
                Text("value2: " + String(model.handValue2))
            }
        }
    }
}

struct TestRankStoreView_Previews: PreviewProvider {
    static var previews: some View {
        TestRankStoreView()
    }
}

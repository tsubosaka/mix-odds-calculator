//
//  OmahaTwoBoadHighLowView.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2022/01/05.
//

import SwiftUI

struct OmahaTwoBoadHighLowView: View {
    @State private var hand1 = ""
    @State private var hand2 = ""
    @State private var dead = ""
    @State private var board1 = ""
    @State private var board2 = ""
    @ObservedObject var omahaModel = OmahaTwoBoardModelHighLow()

    var body: some View {
        VStack{
            Text("Omaha hi/low odds calculator").font(.title).padding(.bottom)
            Group{
            HStack{
                Text("Player1 Hand")
                Spacer()
            }
            TextField("Ad 2h 3h 4c 5s", text: $hand1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack{
                Text("Player2 Hand")
                Spacer()
            }
            TextField("Th Js Qs Kh Ac", text: $hand2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack{
                Text("Board1")
                Spacer()
            }
            TextField("2d 3c 7c", text: $board1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack{
                Text("Board2")
                Spacer()
            }
            TextField("Jh Jd 5c", text: $board2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack{
                Text("Dead Hand")
                Spacer()
            }
            TextField("2d", text: $dead)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Button(action: {
                omahaModel.calculateOdds(hand1: hand1, hand2: hand2, board1: board1, board2: board2, deadCard: dead, numberOfSimulations: 1000)
            }){
                Text("計算")
            }.alert(isPresented: $omahaModel.isError){
                Alert(title: Text("エラー"), message: Text(omahaModel.errorMessage),
                      dismissButton: .default(Text("OK")))
            }
            if(omahaModel.isCalculated){
                Group{
                    HStack{
                        Text("Player1 Hand")
                        Spacer()
                    }
                    HStack{
                        Text(omahaModel.player_card1)
                        Spacer()
                    }
                    HStack{
                        Text("Player2 Hand")
                        Spacer()
                    }
                    HStack{
                        Text(omahaModel.player_card2)
                        Spacer()
                    }
                    HStack{
                        Text("Dead Hand")
                        Spacer()
                    }
                    HStack{
                        Text(omahaModel.dead_card)
                        Spacer()
                    }
                }
                Group{
                    HStack{
                        Text("Board1")
                        Spacer()
                    }
                    HStack{
                        Text(omahaModel.board1)
                        Spacer()
                    }
                    HStack{
                        Text("Board2")
                        Spacer()
                    }
                    HStack{
                        Text(omahaModel.board2)
                        Spacer()
                    }
                    HStack{
                        Text(String(omahaModel.simulationNum) + "回シミュレーション結果")
                        Spacer()
                    }
                    HStack{
                        Text("Player1 High")
                        Spacer()
                    }
                    Text("win: " + String(omahaModel.win1_high))
                    Text("tie: " + String(omahaModel.tie1_high))
                }
                Group{
                    HStack{
                        Text("Low発生回数")
                        Spacer()
                    }
                    Text("low発生回数: " + String(omahaModel.low_appear))
                    HStack{
                        Text("Player1 Low")
                        Spacer()
                    }
                    Text("win: " + String(omahaModel.win1_low))
                    Text("tie: " + String(omahaModel.tie1_low))
                    HStack{
                        Text("Player1 期待値")
                        Spacer()
                    }
                    Text("exp: " + String(omahaModel.exp_player_1))
                }
            }
        }

    }
}

struct OmahaTwoBoadHighLowView_Previews: PreviewProvider {
    static var previews: some View {
        OmahaTwoBoadHighLowView()
    }
}

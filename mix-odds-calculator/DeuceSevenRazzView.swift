//
//  DeuceSevenRazzView.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2021/12/28.
//

import SwiftUI

struct DeuceSevenRazzView: View {
    @State private var hand1 = ""
    @State private var hand2 = ""
    @State private var hand3 = ""
    @State private var dead = ""
    @ObservedObject var razzModel = DeuceSevenRazzModel()
    var body: some View {
        VStack{
            Text("2-7 Razz odds calculator").font(.title).padding(.bottom)
            Group{
            HStack{
                Text("Player1 Hand")
                Spacer()
            }
            TextField("2d 3h 7c", text: $hand1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack{
                Text("Player2 Hand")
                Spacer()
            }
            TextField("2d 3h 7c", text: $hand2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack{
                Text("Player3 Hand")
                Spacer()
            }
            TextField("2d 3h 7c", text: $hand3)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack{
                Text("Dead Hand")
                Spacer()
            }
            TextField("2d 3h 7c", text: $dead)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Button(action: {
                razzModel.calculateOdds(hand1: hand1, hand2: hand2, hand3: hand3, deadCard: dead, numberOfSimulations: 300)
            }){
                Text("計算")
            }.alert(isPresented: $razzModel.isError){
                Alert(title: Text("エラー"), message: Text(razzModel.errorMessage),
                      dismissButton: .default(Text("OK")))
            }
            if(razzModel.isCalculated){
                Group{
                    HStack{
                        Text("Player1 Hand")
                        Spacer()
                    }
                    HStack{
                        Text(razzModel.player_hand1)
                        Spacer()
                    }
                    HStack{
                        Text("Player2 Hand")
                        Spacer()
                    }
                    HStack{
                        Text(razzModel.player_hand2)
                        Spacer()
                    }
                    HStack{
                        Text("Dead Hand")
                        Spacer()
                    }
                    HStack{
                        Text(razzModel.dead_hand)
                        Spacer()
                    }
                }
                Group{
                    HStack{
                        Text(String(razzModel.simulationNum) + "回シミュレーション結果")
                        Spacer()
                    }
                    HStack{
                        Text("Player1 勝利回数")
                        Spacer()
                    }
                    HStack{
                        Text(String(razzModel.win1))
                        Spacer()
                    }
                    HStack{
                        Text("Player2 勝利回数")
                        Spacer()
                    }
                    HStack{
                        Text(String(razzModel.win2))
                        Spacer()
                    }
                    HStack{
                        Text("tie回数")
                        Spacer()
                    }
                    HStack{
                        Text(String(razzModel.tie12))
                        Spacer()
                    }

                }
            }
        }
        .padding()
    }
    
}

struct DeuceSevenRazzView_Previews: PreviewProvider {
    static var previews: some View {
        DeuceSevenRazzView()
.previewInterfaceOrientation(.portraitUpsideDown)
    }
}

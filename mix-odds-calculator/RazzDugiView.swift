//
//  RazzDugiView.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2022/01/03.
//

import SwiftUI

struct RazzDugiView: View {
    @State private var hand1 = ""
    @State private var hand2 = ""
    @State private var hand3 = ""
    @State private var dead = ""
    @ObservedObject var razzModel = RazzDugiModel()
    var body: some View {
        VStack{
            Text("Razzdugi odds calculator").font(.title).padding(.bottom)
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
                razzModel.calculateOdds(hand1: hand1, hand2: hand2, hand3: hand3, deadCard: dead)
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
                        Text("1000回シミュレーション結果")
                        Spacer()
                    }
                    HStack{
                        Text("Player1 Razz")
                        Spacer()
                    }
                    Text("win: " + String(razzModel.win1_razz))
                    Text("tie: " + String(razzModel.tie1_razz))
                    HStack{
                        Text("Player1 Badugi")
                        Spacer()
                    }
                    Text("win: " + String(razzModel.win1_badugi))
                    Text("tie: " + String(razzModel.tie1_badugi))
                    HStack{
                        Text("Player1 期待値")
                        Spacer()
                    }
                    Text("exp: " + String(razzModel.exp_player1))
                }
            }
        }
        .padding()
    }

}

struct RazzDugiView_Previews: PreviewProvider {
    static var previews: some View {
        RazzDugiView()
    }
}

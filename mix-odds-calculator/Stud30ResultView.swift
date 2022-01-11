//
//  Stud30ResultView.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2022/01/10.
//

import SwiftUI

struct Stud30ResultView: View {
    @ObservedObject var razzModel: Stud30Model
    init(razzModel: Stud30Model){
        self.razzModel = razzModel
    }
    var body: some View {
        VStack{
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
                    Text("Player1 30")
                    Spacer()
                }
                Text("win: " + String(razzModel.win1_30))
                Text("tie: " + String(razzModel.tie1_30))
                HStack{
                    Text("Player1 High")
                    Spacer()
                }
                Text("win: " + String(razzModel.win1_high))
                Text("tie: " + String(razzModel.tie1_high))
                HStack{
                    Text("Player1 期待値")
                    Spacer()
                }
                Text("exp: " + String(razzModel.exp_player1))
            }

        }
    }

}

struct Stud30ResultView_Previews: PreviewProvider {
    static let model: Stud30Model = {
        var razzModel: Stud30Model = Stud30Model()
        razzModel.simulationNum = 100
        razzModel.player_hand1 = "8h 9d 7c"
        razzModel.player_hand2 = "4h 5d 6c"
        return razzModel
    }()

    static var previews: some View {
        Stud30ResultView(razzModel: model)
    }
}

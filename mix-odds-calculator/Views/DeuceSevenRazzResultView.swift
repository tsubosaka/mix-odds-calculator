//
//  DeuceSevenRazzResultView.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2022/01/05.
//

import SwiftUI

struct DeuceSevenRazzResultView: View {
    @ObservedObject var razzModel: DeuceSevenRazzModel
    init(razzModel: DeuceSevenRazzModel){
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
}

struct DeuceSevenRazzResultView_Previews: PreviewProvider {
    static let model: DeuceSevenRazzModel = {
        var razzModel: DeuceSevenRazzModel = DeuceSevenRazzModel()
        razzModel.simulationNum = 100
        razzModel.player_hand1 = "2h 3d 7c"
        razzModel.player_hand2 = "4h 5d 6c"
        return razzModel
    }()
    static var previews: some View {
        DeuceSevenRazzResultView(razzModel: model)
    }
}

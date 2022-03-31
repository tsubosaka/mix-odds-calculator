//
//  StudResultView.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2022/03/31.
//

import SwiftUI

struct StudResultView: View {
    @ObservedObject var studModel : StudModel
    init(model : StudModel){
        studModel = model
    }

    var body: some View {
        VStack{
            Group{
                HStack{
                    Text("Player1 Hand")
                    Spacer()
                }
                HStack{
                    Text(studModel.player_hand1)
                    Spacer()
                }
                HStack{
                    Text("Player2 Hand")
                    Spacer()
                }
                HStack{
                    Text(studModel.player_hand2)
                    Spacer()
                }
                if(studModel.playerNum == 3){
                    HStack{
                        Text("Player3 Hand")
                        Spacer()
                    }
                    HStack{
                        Text(studModel.player_hand3)
                        Spacer()
                    }
                }
                HStack{
                    Text("Dead Hand")
                    Spacer()
                }
                HStack{
                    Text(studModel.dead_hand)
                    Spacer()
                }
            }
            Group{
                HStack{
                    Text(String(studModel.simulationNum) + "回シミュレーション結果")
                    Spacer()
                }
                HStack{
                    Text(studModel.highName)
                    Spacer()
                }
                HStack{
                    Text("Player 1 win : " + String(studModel.win1_h))
                    Spacer()
                }
                HStack{
                    Text("Player 2 win : " + String(studModel.win2_h))
                    Spacer()
                }
                if(studModel.playerNum == 3){
                    HStack{
                        Text("Player 3 win : " + String(studModel.win3_h))
                        Spacer()
                    }
                }
            }
            if(studModel.isSplitGame){
                Group{
                    HStack{
                        Text(studModel.lowName)
                        Spacer()
                    }
                    HStack{
                        Text("Player 1 win : " + String(studModel.win1_l))
                        Spacer()
                    }
                    HStack{
                        Text("Player 2 win : " + String(studModel.win2_l))
                        Spacer()
                    }
                    if(studModel.playerNum == 3){
                        HStack{
                            Text("Player 3 win : " + String(studModel.win3_l))
                            Spacer()
                        }
                    }
                    HStack{
                        Text("scoop")
                        Spacer()
                    }
                    HStack{
                        Text("Player 1: " + String(studModel.scoop_1))
                        Spacer()
                    }
                    HStack{
                        Text("Player 2: " + String(studModel.scoop_2))
                        Spacer()
                    }
                    if(studModel.playerNum == 3){
                        HStack{
                            Text("Player 3: " + String(studModel.scoop_3))
                            Spacer()
                        }
                    }
                }
            }
            Group{
                HStack{
                    Text("Equity")
                    Spacer()
                }
                HStack{
                    Text("Player 1 equity : " + String(studModel.equity1) + "%")
                    Spacer()
                }
                HStack{
                    Text("Player 2 equity : " + String(studModel.equity2) + "%")
                    Spacer()
                }
                if(studModel.playerNum == 3){
                    HStack{
                        Text("Player 3 equity : " + String(studModel.equity3) + "%")
                        Spacer()
                    }
                }
            }
        }
    }
}

struct StudResultView_Previews: PreviewProvider {
    static var previews: some View {
        StudResultView(model: StudHighLowModel())
    }
}

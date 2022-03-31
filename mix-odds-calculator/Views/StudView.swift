//
//  StudView.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2022/03/31.
//

import SwiftUI

struct StudView: View {
    @State private var hand1 = ""
    @State private var hand2 = ""
    @State private var hand3 = ""
    @State private var dead = ""
    @ObservedObject var studModel : StudModel
    init(model : StudModel){
        studModel = model
    }

    var body: some View {
        VStack{
            Text(studModel.gameName + " odds calculator").font(.title).padding(.bottom)
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
            TextField("Td Th Tc", text: $hand2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack{
                Text("Player3 Hand")
                Spacer()
            }
            TextField("9d 9h 9c", text: $hand3)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack{
                Text("Dead Hand")
                Spacer()
            }
            TextField("2d 3h 7c", text: $dead)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Button(action: {
                studModel.calculateOdds(hand1: hand1, hand2: hand2, hand3: hand3, deadCard: dead, numberOfSimulations: 6000)
            }){
                Text("計算")
            }.alert(isPresented: $studModel.isError){
                Alert(title: Text("エラー"), message: Text(studModel.errorMessage),
                      dismissButton: .default(Text("OK")))
            }
            if(studModel.isCalculated){
                StudResultView(model: studModel)
            }
        }
        .padding()

    }
}

struct StudView_Previews: PreviewProvider {
    static var previews: some View {
        StudView(model: StudHighLowModel())
    }
}

//
//  ContentView.swift
//  mix-odds-calculator
//
//  Created by 坪坂正志 on 2021/12/28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            List{
                NavigationLink(
                    destination: StudView(model: StudHighLowModel())){
                    Text("Stud Hi/Lo").font(.title)
                }
                NavigationLink(
                    destination: StudView(model: DeuceSevenRazzModel())){
                    Text("2-7 Razz").font(.title)
                }
                NavigationLink(destination: RazzDugiView()){
                    Text("Razz dugi").font(.title)
                }
                NavigationLink(destination: Stud30View()){
                    Text("Stud30").font(.title)
                }
                NavigationLink(destination: OmahaTwoBoadHighView()){
                    Text("Omaha Double Board").font(.title)
                }
                NavigationLink(destination: OmahaTwoBoadHighLowView()){
                    Text("Omaha Hi/Lo best/best").font(.title)
                }
            }.navigationTitle(Text("Mix Game odds calculator"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
.previewInterfaceOrientation(.portraitUpsideDown)
    }
}

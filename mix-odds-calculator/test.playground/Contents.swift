import Foundation
let start = Date()
var model = Stud30Model()
model.calculateOdds(hand1: "Td Tc 2c 3h", hand2: "7h 7s 7c 7d", hand3: "", deadCard: "Th",
                    numberOfSimulations: 1000)
let elapsed = Date().timeIntervalSince(start)
print(elapsed)

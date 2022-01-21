import Foundation
let start = Date()
var model = RazzDugiModel()

func getDeck() -> [PlayingCard]{
    var result: [PlayingCard] = []
    for num in 2...14{
        result.append(PlayingCard(suit: Suit.club,number: num))
        result.append(PlayingCard(suit: Suit.diamond,number: num))
        result.append(PlayingCard(suit: Suit.heart,number: num))
        result.append(PlayingCard(suit: Suit.spade,number: num))
    }
    return result
}

var deck: [PlayingCard] = getDeck()
for _ in 1...10000{
    //deck.shuffle()
    var player1 : [PlayingCard] = []
    var player2 : [PlayingCard] = []
    let leftCard = 7 - player1.count
    if leftCard != 0{
        for i in 1...leftCard{
            player1.append(deck[i - 1])
        }
        for i in 1...leftCard{
            player2.append(deck[i - 1 + leftCard])
        }
    }
}

let elapsed = Date().timeIntervalSince(start)
print(elapsed)

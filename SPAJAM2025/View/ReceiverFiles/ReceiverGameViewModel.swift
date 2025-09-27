import SwiftUI
import GameKit
import Combine

class ReceiverGameViewModel: ObservableObject {
    @Published var currentView: ReceiverViewIdentifier = .finding
    @Published var selectedQuestion: String = ""
    @Published var selectedStarInfo: String = ""
    @Published var isPushedAnswer: Bool = false
    @Published var isCorrectAnswer: Bool = false
    
    @Published var starLoader = StarLoader()
}

struct GameInfoFromReceiver:Codable{
    var playerID: String = ""
    var selectedQuestion: String = ""
    var isPushedAnswer: Bool = false
}

struct GameInfoFromPublisher:Codable{
    var playerID: String = ""
    var isLiar :Bool = false
    var isAnswered: Bool = false
}

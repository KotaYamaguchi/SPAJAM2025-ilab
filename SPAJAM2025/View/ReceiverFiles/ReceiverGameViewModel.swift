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

// MARK: - 変更点
// Publisherからの返答内容を保持するプロパティを追加
struct GameInfoFromPublisher:Codable{
    var playerID: String = ""
    var answer: String = "" // 「はい」か「いいえ」の文字列を格納
    var isLiar :Bool = false
    var isAnswered: Bool = false
}

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
    @Published var gameCenterManager: GameCenterManager
    
    func sendIndex(_ index: Int) {
        gameCenterManager.sendIndex(index)
        print("インデックス \(index) を送信しました。")
    }

    // 質問送信メソッド
    func sendSelectedQuestion() {
        let playerId = GKLocalPlayer.local.gamePlayerID
        let action = PlayerAction(
            playerId: playerId,
            action: .selectIndex, // or .selectQuestion 等、用途に応じて
            position: nil,
            selectedIndex: nil, // 必要なら質問IDなどをセット
            DoubtStarPositionX: nil,
            DoubtStarPositionY: nil,
            doubtStarAzimuth: nil,
            doubtStarAltitude: nil
        )
        // 質問文本体を送信する場合は、PlayerActionに項目追加も検討
        gameCenterManager.broadcastPlayerAction(action)
        print("質問 '\(selectedQuestion)' を送信しました。")
    }
    
    // ZUBARI送信メソッド
    func sendSelectedStarInfo() {
        let playerId = GKLocalPlayer.local.gamePlayerID
        let action = PlayerAction(
            playerId: playerId,
            action: .selectDoubtStar,
            position: nil,
            selectedIndex: nil, // もしインデックスや情報必要ならここに
            DoubtStarPositionX: nil,
            DoubtStarPositionY: nil,
            doubtStarAzimuth: nil,
            doubtStarAltitude: nil
        )
        // starInfo本体を送信する場合はPlayerAction構造体の拡張も検討
        gameCenterManager.broadcastPlayerAction(action)
        print("ZUBARI情報 '\(selectedStarInfo)' を送信しました。")
    }
    
    init(gameCenterManager: GameCenterManager = GameCenterManager()) {
        self.gameCenterManager = gameCenterManager
    }
}

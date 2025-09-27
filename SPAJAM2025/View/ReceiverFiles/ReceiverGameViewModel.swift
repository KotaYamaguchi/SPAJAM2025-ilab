import SwiftUI
import GameKit
import Combine

class ReceiverGameViewModel: ObservableObject {
    @Published var currentView: ReceiverViewIdentifier = .finding
    @Published var selectedQuestion: String = ""
    @Published var selectedStarInfo: String = ""
    @Published var isPushedAnswer: Bool = false
    @Published var isCorrectAnswer: Bool = false
    @Published var lastGuessResult: String = "" // 推測結果のフィードバック用
    
    // 回答者がタップして選択した星（推測）
    @Published var guessedStar: UserStar? = nil
    
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

    @Published var gameCenterManager: GameCenterManager
    
    // 正解との許容誤差（度）
    private let tolerance: Double = 2.0 // 許容誤差を少し厳しくする

    // 推測をチェックする関数
    func checkGuess() {
        guard let hiddenCoords = gameCenterManager.hiddenStarCoordinates else {
            lastGuessResult = "まだ相手が星を隠していません"
            return
        }
        
        guard let guessedCoords = guessedStar else {
            lastGuessResult = "星を選択してからZUBARIを押してください"
            return
        }

        // 緯度と経度の差を計算
        let azimuthDifference = abs(guessedCoords.azimuth - hiddenCoords.azimuth)
        let altitudeDifference = abs(guessedCoords.altitude - hiddenCoords.altitude)

        // 360度の境界をまたぐ場合の考慮
        let wrappedAzimuthDifference = min(azimuthDifference, 360 - azimuthDifference)

        print("正解座標: (方位角 \(hiddenCoords.azimuth), 高度 \(hiddenCoords.altitude))")
        print("回答座標: (方位角 \(guessedCoords.azimuth), 高度 \(guessedCoords.altitude))")
        print("座標の誤差: (方位角 \(wrappedAzimuthDifference), 高度 \(altitudeDifference))")

        if wrappedAzimuthDifference <= tolerance && altitudeDifference <= tolerance {
            lastGuessResult = "正解！"
            isCorrectAnswer = true
            // 自分の勝ちを設定し、相手に勝利を通知する
            gameCenterManager.gameOutcome = .won
            gameCenterManager.sendWinNotification()
        } else {
            lastGuessResult = "惜しい！もう一度探してみよう"
        }
    }
    
    func sendIndex(_ index: Int) {
        gameCenterManager.sendIndex(index)
        print("インデックス \(index) を送信しました。")
    }

    // 質問送信メソッド
    func sendSelectedQuestion() {
        let playerId = GKLocalPlayer.local.gamePlayerID
        let action = PlayerAction(
            playerId: playerId,
            action: .selectIndex,
            position: nil,
            selectedIndex: nil,
            DoubtStarPositionX: nil,
            DoubtStarPositionY: nil,
            doubtStarAzimuth: nil,
            doubtStarAltitude: nil
        )
        gameCenterManager.broadcastPlayerAction(action)
        print("質問 '\(selectedQuestion)' を送信しました。")
    }
    
    init(gameCenterManager: GameCenterManager) {
        self.gameCenterManager = gameCenterManager
    }

}

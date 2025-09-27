import GameKit
import SwiftUI
import Combine

// プレイヤーの役割を定義するEnum
enum PlayerRole: String {
    case publisher // 出題者
    case receiver  // 回答者
    case unknown   // 未定
}

// NSObjectを継承してObservableObjectに準拠
class GameCenterManager: NSObject, ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentMatch: GKMatch?
    @Published var lastReceivedAction: PlayerAction?
    @Published var localPlayerAvatar: Image? = nil
    @Published var opponentAvatar: Image? = nil
    @Published var localPlayerRole: PlayerRole = .unknown // 自分の役割を保持
    
    // MARK: - 変更点①: 受信したゲーム情報データを保持するプロパティを追加
       @Published var lastReceivedGameInfoFromReceiver: GameInfoFromReceiver?
       @Published var lastReceivedGameInfoFromPublisher: GameInfoFromPublisher?
    
    
    func authenticatePlayer(completion: @escaping (Bool) -> Void) {
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                // 認証画面を表示
                UIApplication.shared.windows.first?.rootViewController?.present(viewController, animated: true, completion: nil)
                completion(false)
                return
            }
            if error != nil {
                print("認証エラー: \(error?.localizedDescription ?? "")")
                self.isAuthenticated = false
                completion(false)
                return
            }
            self.isAuthenticated = GKLocalPlayer.local.isAuthenticated
            completion(self.isAuthenticated)
        }
    }
    
    func loadLocalPlayerAvatar() {
        // 自分のアバターを読み込む
        GKLocalPlayer.local.loadPhoto(for: .normal) { image, error in
            if let image = image {
                DispatchQueue.main.async {
                    self.localPlayerAvatar = Image(uiImage: image)
                }
            }
            if let error = error {
                print("自分のアバターの読み込みエラー: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadOpponentAvatar(for player: GKPlayer) {
        player.loadPhoto(for: .normal) { image, error in
            if let image = image {
                DispatchQueue.main.async {
                    self.opponentAvatar = Image(uiImage: image)
                }
            }
            if let error = error {
                print("対戦相手のアバターの読み込みエラー: \(error.localizedDescription)")
            }
        }
    }
    
    // 役割を決定する関数
    func determinePlayerRoles() {
        guard let match = currentMatch, let opponent = match.players.first else {
            print("役割決定エラー: 対戦相手が見つかりません")
            return
        }
        
        let localPlayerID = GKLocalPlayer.local.gamePlayerID
        let opponentPlayerID = opponent.gamePlayerID
        
        // gamePlayerIDの文字列を比較して、小さい方を "publisher" とする
        if localPlayerID < opponentPlayerID {
            self.localPlayerRole = .publisher
            print("あなたの役割: 出題者 (Publisher)")
        } else {
            self.localPlayerRole = .receiver
            print("あなたの役割: 回答者 (Receiver)")
        }
    }
}

extension GameCenterManager {
    func startMatchmaking() {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        request.playerGroup = 4130
        
        GKMatchmaker.shared().findMatch(for: request) { match, error in
            if let error = error {
                print("マッチメイキングエラー: \(error.localizedDescription)")
                return
            }
            self.currentMatch = match
            self.setupMatchHandlers()
        }
    }
}
extension GameCenterManager {
    /// 現在の対戦から切断する関数
        func disconnectFromMatch() {
            // currentMatchが存在するか安全に確認
            guard let match = currentMatch else { return }
            
            // 1. マッチから切断する
            match.disconnect()
            
            // 2. 自分の状態をリセットする
            // これにより、UIが自動的に待機画面に戻る
            DispatchQueue.main.async {
                self.currentMatch = nil
            }
            
            print("マッチから切断しました。")
        }
}



extension GameCenterManager {
    func setupMatchHandlers() {
        currentMatch?.delegate = self
    }
    
    func sendData<T: Codable>(_ data: T) {
        guard let match = currentMatch else {
            print("マッチしているユーザーが存在しません")
            return
        
        }
        
        do {
            let jsonData = try JSONEncoder().encode(data)
            try match.sendData(toAllPlayers: jsonData, with: .reliable)
        } catch {
            print("データ送信エラー: \(error)")
        }
    }
}

// NSObjectを継承しているためGKMatchDelegateに準拠可能
extension GameCenterManager: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        // 受信したデータを処理
        handleReceivedData(data)
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        // プレイヤー接続状態の変更を処理
        print("プレイヤー \(player.displayName) の状態が変更されました: \(state.rawValue)")
        
        // 相手プレイヤーが接続状態になったら、アバターを読み込み、役割を決定する
        if state == .connected {
            loadOpponentAvatar(for: player)
            determinePlayerRoles()
        }
    }
}

extension GameCenterManager {
    
    func sendIndex(_ index: Int) {
        let playerId = GKLocalPlayer.local.gamePlayerID
        
        let action = PlayerAction(
            playerId: playerId, action: .selectIndex, position: nil, selectedIndex: index, DoubtStarPositionX: nil,DoubtStarPositionY: nil,doubtStarAzimuth: nil,doubtStarAltitude: nil
        )
        broadcastPlayerAction(action)
        print("インデックス \(index) を送信しました。")
    }
    //レシーバーからのゲーム中の情報送信
    func sendGameInfoFromReceiver(selectedQuestion: String, isPushedAnswer: Bool) {
    let playerId = GKLocalPlayer.local.gamePlayerID
        let data = GameInfoFromReceiver(playerID: playerId, selectedQuestion: selectedQuestion, isPushedAnswer: isPushedAnswer)
        broadcastGameInfoFromReceiver(data)
        print("ゲーム情報\(data.isPushedAnswer),\(data.selectedQuestion)を送信しました。")
    }
    func broadcastGameInfoFromReceiver(_ info: GameInfoFromReceiver) {
        sendData(info)
    }
    
    // MARK: - 変更点②: 送信メソッドの引数を更新
      func sendGameInfoFromPublisher(answer: String, isLiar: Bool, isAnswered: Bool) {
          guard let match = currentMatch else {
              print("エラー: 現在のマッチがありません。")
              return
          }

          var gameInfo = GameInfoFromPublisher()
          gameInfo.playerID = GKLocalPlayer.local.gamePlayerID
          gameInfo.answer = answer
          gameInfo.isLiar = isLiar
          gameInfo.isAnswered = isAnswered

          do {
              let data = try JSONEncoder().encode(gameInfo)
              try match.sendData(toAllPlayers: data, with: .reliable)
          } catch {
              print("GameInfoFromPublisherの送信エラー: \(error)")
          }
      }
    func broadcastGameInfoFromPublisher(_ info: GameInfoFromPublisher) {
        sendData(info)
    }
    
    //星の情報送信
    func sendStarAzimuthAltitude(azimuth: Double, altitude: Double) {
            let playerId = GKLocalPlayer.local.gamePlayerID
            let action = PlayerAction(
                playerId: playerId,
                action: .selectDoubtStar,
                position: nil,
                selectedIndex: nil,
                DoubtStarPositionX: nil,  // 互換性のため
                DoubtStarPositionY: nil,  // 互換性のため
                doubtStarAzimuth: azimuth,
                doubtStarAltitude: altitude
            )
            broadcastPlayerAction(action)
            print("天球座標 (方位角: \(azimuth), 高度: \(altitude)) を送信しました。")
        }
    
    func broadcastPlayerAction(_ action: PlayerAction) {
        sendData(action)
    }
    
    // MARK: - 変更点③: 受信データ処理を拡張
        private func handleReceivedData(_ data: Data) {
            
            // GameInfoFromPublisherとしてデコードを試みる
            do {
                let gameInfo = try JSONDecoder().decode(GameInfoFromPublisher.self, from: data)
                DispatchQueue.main.async {
                    self.processGameInfoFromPublisher(gameInfo)
                }
                return
            } catch {
                // デコード失敗時は次のデータ型を試す
            }
            
            // GameInfoFromReceiverとしてデコードを試みる
            do {
                let gameInfo = try JSONDecoder().decode(GameInfoFromReceiver.self, from: data)
                DispatchQueue.main.async {
                    self.processGameInfoFromReceiver(gameInfo)
                }
                return
            } catch {
                // デコード失敗時は次のデータ型を試す
            }
            
            // PlayerActionとしてデコードを試みる
            do {
                let action = try JSONDecoder().decode(PlayerAction.self, from: data)
                DispatchQueue.main.async {
                    self.processPlayerAction(action)
                }
                return
            } catch {
                // デコード失敗時は何もしない
            }
            
            print("受信したデータをどの型にもデコードできませんでした。")
        }
        
        private func processGameInfoFromPublisher(_ info: GameInfoFromPublisher) {
            self.lastReceivedGameInfoFromPublisher = info
            print("受信した返答: \(info.answer), 嘘: \(info.isLiar)")
        }
        
        private func processGameInfoFromReceiver(_ info: GameInfoFromReceiver) {
            self.lastReceivedGameInfoFromReceiver = info
            print("受信した質問: \(info.selectedQuestion)")
        }
    private func processPlayerAction(_ action: PlayerAction) {
            self.lastReceivedAction = action
            
            switch action.action {
            case .selectIndex:
                if let index = action.selectedIndex {
                    print("プレイヤー \(action.playerId) がインデックス \(index) を選択しました。")
                }
            case .move:
                print("プレイヤーが移動しました。")
                
            case .selectDoubtStar:
                if let azimuth = action.doubtStarAzimuth,
                   let altitude = action.doubtStarAltitude {
                    print("天球座標を受信: 方位角 \(azimuth), 高度 \(altitude)")
                }
                
            default:
                print("その他のアクションを受信しました。")
            }
        }
}



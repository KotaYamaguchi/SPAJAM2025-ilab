import GameKit
import SwiftUI
import Combine

// NSObjectを継承してObservableObjectに準拠
class GameCenterManager: NSObject, ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentMatch: GKMatch?
    @Published var lastReceivedAction: PlayerAction?
    
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
    
    //パブリッシャーからのゲーム中の情報送信
    func sendGameInfoFromPublisher(isLiar: Bool, isAnswered: Bool) {
    let playerId = GKLocalPlayer.local.gamePlayerID
        let data = GameInfoFromPublisher(playerID: playerId,isLiar: isLiar, isAnswered: isAnswered)
        broadcastGameInfoFromPublisher(data)
        print("ゲーム情報\(data.isLiar), \(data.isAnswered)を送信しました。")
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
    
    private func handleReceivedData(_ data: Data) {
        do {
            let action = try JSONDecoder().decode(PlayerAction.self, from: data)
            DispatchQueue.main.async {
                self.processPlayerAction(action)
            }
        } catch {
            print("データデコードエラー: \(error)")
        }
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



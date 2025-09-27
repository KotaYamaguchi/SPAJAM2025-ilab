import SwiftUI

struct ContentView: View {
    @StateObject private var gameCenterManager = GameCenterManager()
    
    var body: some View {
        Group {
            if gameCenterManager.currentMatch != nil && !gameCenterManager.isGameFinished {
                // マッチングが成立し、まだゲームが終了していない場合、ゲーム画面（MatchingEndから）を表示
                MatchingEnd()
            } else {
                // マッチング前、またはゲーム終了後は、MatchStartViewを表示
                MatchStartView()
                    .onAppear {
                        // この画面が表示されるたびに、ゲームの状態をリセットする
                        gameCenterManager.resetGame()
                    }
            }
        }
        .environmentObject(gameCenterManager) // gameCenterManagerを全てのViewで共有
    }
}

#Preview {
    ContentView()
}

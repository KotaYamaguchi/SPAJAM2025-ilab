import SwiftUI

struct GameRouterView: View {
    @EnvironmentObject var gameCenterManager: GameCenterManager

    var body: some View {
        // gameCenterManager.localPlayerRole の値に基づいて表示するビューを切り替える
        switch gameCenterManager.localPlayerRole {
        case .publisher:
            // 出題者側の初期ビュー
            PublisherGameView()
                .navigationBarBackButtonHidden(true)
        case .receiver:
            // 回答者側の初期ビュー
            ReceiverGameView(gameCenterManager: gameCenterManager)
                .navigationBarBackButtonHidden(true)
        case .unknown:
            // 役割がまだ決まっていない場合に表示するビュー
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                Text("役割を決定しています...")
                    .foregroundColor(.white)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.ignoresSafeArea())
        }
    }
}

#Preview {
    // Preview用に、役割をダミーで設定して確認できます
    let manager = GameCenterManager()
    // manager.localPlayerRole = .publisher
    // manager.localPlayerRole = .receiver
    return GameRouterView()
        .environmentObject(manager)
}

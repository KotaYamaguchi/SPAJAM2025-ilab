
//  PublisherGameView.swift
//  SPAJAM2025
//
//  Created by Kota Yamaguchi on 2025/09/27.
//

import SwiftUI
//出題者側のゲームプレイ画面です．
struct PublisherGameView: View {
    @State private var currentView: PublisherViewIdentifier = .starHiding
    // MARK: - 追加①: GameCenterManagerを環境オブジェクトとして利用
    @EnvironmentObject var gameCenterManager: GameCenterManager
    
    // MARK: - 追加②: 受信した質問を保持するState変数
    @State private var receivedQuestion: String = ""
    
    // StarHidingViewから状態を昇格
    @StateObject private var starLoader = StarLoader()
    @State private var createdStar: UserStar? = nil
    @State private var isLocked = false
    
    var body: some View {
        ZStack{
            LinearGradient(
                
                colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.1),
                    Color(red: 0.1, green: 0.1, blue: 0.25),
                    Color(red: 0.2, green: 0.4, blue: 0.5)
                ],
                
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            
            
            switch currentView {
            case .starHiding:
                StarHidingView(
                    currentView: $currentView,
                    createdStar: $createdStar,
                    isLocked: $isLocked,
                    stars: $starLoader.stars
                )
            case .receiveQuestion:
                // MARK: - 変更点①: PublisherReceiveQuestionViewに受信した質問とcurrentViewのBindingを渡す
                PublisherReceiveQuestionView(
                    questionText: receivedQuestion,
                    currentView: $currentView
                )
            case .returnToStarView:
                StarGazingView(
                    userStar: $createdStar,
                    stars: $starLoader.stars,
                    isLocked: $isLocked
                )
            }
        }
        .fullScreenCover(isPresented: .constant(gameCenterManager.gameOutcome != nil)) {
            if let outcome = gameCenterManager.gameOutcome {
                GameResultView(outcome: outcome)
                    .environmentObject(gameCenterManager)
                
            }
        }
        
        // MARK: - 追加③: GameCenterManagerからのデータ受信を監視
        .onReceive(gameCenterManager.$lastReceivedGameInfoFromReceiver) { gameInfo in
            guard let info = gameInfo else { return }
            
            // isPushedAnswerがfalseの場合（= 質問が来た場合）のみ処理
            if !info.isPushedAnswer {
                self.receivedQuestion = info.selectedQuestion
                self.currentView = .receiveQuestion
                
            }
        }
        .onAppear(perform: resetViewStates)
    }
    
    private func resetViewStates() {
        currentView = .starHiding
        receivedQuestion = ""
        createdStar = nil
        isLocked = false
        gameCenterManager.lastReceivedGameInfoFromReceiver = nil
    }
}

enum PublisherViewIdentifier: String {
    case starHiding
    case receiveQuestion
    case returnToStarView
}
#Preview {
    PublisherGameView()
}



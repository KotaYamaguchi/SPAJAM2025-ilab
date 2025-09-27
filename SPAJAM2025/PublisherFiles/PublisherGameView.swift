//
//  PublisherGameView.swift
//  SPAJAM2025
//
//  Created by Kota Yamaguchi on 2025/09/27.
//

import SwiftUI
//出題者側のゲームプレイ画面です．
struct PublisherGameView: View {
    @State private var currentView: PublisherViewIdentifier = .starHiding
    var body: some View {
        ZStack{
            switch currentView {
            case .starHiding:
                StarHidingView(currentView: $currentView)
            case .receiveQuestion:
                PublisherReceiveQuestionView()
            case .gameResult:
                Text("結果")
            case .waitingForQuestion:
                Text("質問待ち")
            }
        }
    }
}

enum PublisherViewIdentifier: String {
    case starHiding
    case waitingForQuestion
    case receiveQuestion
    case gameResult
}
#Preview {
    PublisherGameView()
}



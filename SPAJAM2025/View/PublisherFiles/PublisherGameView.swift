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
    
    //送信するデータ
    //出題者に送信する質問の文字列
    @State private var isAnsweredQuestion: Bool = false
    //出題者に送信する星の情報，インデックスなのかUUIDなのかたいし判断
    @State private var hideStarInfo: String = ""
    //ZUBARIボタンを押されたことを受け取り，正誤判定を行うことを通知
    @State private var isPushedAnswer: Bool = false
    //送信するデータここまで
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
                StarHidingView(currentView: $currentView)
            case .receiveQuestion:
                PublisherReceiveQuestionView()
            case .gameResult:
                //相手が回答したフラグを受け取ったらこの画面に遷移
                Text("結果")
            case .gamePlay:
                //星が表示されているだけの画面
                Text("ゲームプレイ")
            }
        }
    }
}

enum PublisherViewIdentifier: String {
    case starHiding
    case gamePlay
    case receiveQuestion
    case gameResult
}
#Preview {
    PublisherGameView()
}



//
//  ReceiverGameView.swift.swift
//  SPAJAM2025
//
//  Created by Kota Yamaguchi on 2025/09/27.
//

import SwiftUI
//回答者側のゲームプレイ画面です．
struct ReceiverGameView: View {
    @State private var currentView:ReceiverViewIdentifier = .finding
    
    //送信するデータ
    //出題者に送信する質問の文字列
    @State private var selectedQuestion: String = ""
    //出題者に送信する星の情報，インデックスなのかUUIDなのかたいし判断
    @State private var selectedStarInfo: String = ""
    //ZUBARIボタンを押して正誤判定を行うことを通知
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
            case .finding:
                ReceiverFindingView()
            case .result:
                ReceiverResultView()
            }
        }
        
    }
}

enum ReceiverViewIdentifier: String{
    case finding
    case result
}







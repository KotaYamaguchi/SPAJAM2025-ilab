//
//  ReceiverResultView.swift
//  SPAJAM2025
//
//  Created by Kota Yamaguchi on 2025/09/27.
//

import SwiftUI

struct ReceiverResultView: View {
    // 正解・不正解の状態を管理するState変数
    // 外部から渡されることを想定し、@Stateのままにしていますが、必要に応じて@Bindingなどに変更してください。
    @State private var isCorrectAnswer = true

    // アニメーションのトリガーとなるState変数
    @State private var animate = false
    
    // isCorrectAnswerがfalseの時の回転角度を管理するState変数
    @State private var incorrectRotationDegrees: Double = 0.0
    
    // 画面外に配置するためのオフセット量
    private let offscreenOffset: CGFloat = 400

    var body: some View {
        VStack{
            ZStack{
                Color(red: 0.1, green: 0.1, blue: 0.16)
                    .ignoresSafeArea()
                
                if isCorrectAnswer {
                    Group{
                        Image("ZUBOSHI_logo_mask")
                            .resizable()
                            .brightness(0.12)
                            .scaleEffect(3.0) // 画像自体のスケールは維持
                            .brightness(0)
                            .mask {
                                Text("ZUBOSHI")
                                    .blur(radius: 1)
                                    .shadow(radius: 10)
                                    .font(.system(size: 80, weight: .black))
                            }
                    }
                    .frame(width: 500)
                    // --- アニメーションのための修飾子 ---
                    .scaleEffect(animate ? 1.0 : 100.0)
                    .ignoresSafeArea()

                } else {
                    Group{
                        Image("ZUBOooN_logo_mask")
                            .resizable()
                            .brightness(-0.1)
                            .scaleEffect(3.0) // 画像自体のスケールは維持
                            .brightness(0)
                            .mask {
                                Text("ZUBoooN")
//                                    .blur(radius: 1)
                                    .shadow(radius: 10)
                                    .font(.system(size: 80, weight: .black))
                            }
                    }
                    .frame(width: 500)
                    // --- アニメーションのための修飾子 ---
                    .scaleEffect(animate ? 1.0 : 100.0)
                    // State変数を使って回転角度を動的に変更
                    .rotationEffect(.degrees(incorrectRotationDegrees))
                    .ignoresSafeArea()
                }
            }
        }
        // ビューが表示されたときにアニメーションを開始
        .onAppear {
            // 共通のスケールアニメーション
            withAnimation(.easeOut(duration: 0.3)){
                animate = true
            }
            
            // isCorrectAnswerがfalseの場合のみ、追加の回転アニメーションを実行
            if !isCorrectAnswer {
                // 0.5秒後に実行
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    // withAnimationで角度の変更をアニメーションさせる
                    withAnimation(.spring(duration: 0.2)) {
                        self.incorrectRotationDegrees = 10
                    }
                }
            }
        }
    }
}


#Preview{
    ReceiverResultView()
}


//
//  MatchStartView.swift
//  SPAJAM2025
//
//  Created by すさきひとむ on 2025/09/27.
//

import SwiftUI

struct MatchStartView: View {
    let dialogtitle = [
        "今夜は星がきれいですね",
        "誰かと夜空を眺めますか？"
    ]
    
    // 現在表示するテキストの数を管理するState
    @State private var tapCount: Int = 0
    
    //アニメーションの速度
    let fadeIn : Double = 1.0
    
    var body: some View {
        ZStack{
            // 背景色（濃いネイビー）
            Color(red: 0.1, green: 0.1, blue: 0.4)
                .ignoresSafeArea()
            
            
            VStack(spacing: 0){
                
                HStack {
                    Spacer()
                    // 三日月アイコン（SF Symbolsを使用）
                    Image(systemName: "moon.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.yellow)
                        .opacity(0.6) // 少し不透明度を下げて夜空の雰囲気に
                        .padding(.trailing, 43)
                }
                .padding(.top)
                
                Spacer()
                
                if tapCount == 0 {
                    
                    VStack{
                        Text("今夜は月が綺麗ですね")
                            .padding(.bottom,30)
                            .font(.system(size:35))
                            .foregroundColor(.white)
                            .transition(.opacity)
                        
                        Text("タップ")
                            .font(.title)
                            .foregroundColor(.gray.opacity(0.8))
                    }
                    .transition(.opacity)
                }
                
                if tapCount >= 1 {
                    Text("誰かと夜空を眺めますか？")
                        .padding(.bottom, 60)
                        .font(.system(size:30))
                        .foregroundColor(.white)
                        .transition(.opacity)
                        .transition(.opacity)
                    
                    
                    Button {
                        
                    } label: {
                        Text("マッチングスタート")
                            .font(.headline)
                            .frame(width: 250)
                            .padding()
                            .background(Color.black.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(32)
                            .shadow(color: .black.opacity(0.4) ,radius: 3, x: 0, y: 4)
                        
                        
                    }
                    
                    .offset(y: 100)
                    
                    
                    
                    
                    
                    
                    
                }
                    
               Spacer()
                
            }
        }.onTapGesture { // Stateの変更を withAnimation で囲むことで、要素の切り替え（if文の切り替わり）にアニメーションが適用される
            if tapCount < 1 { // 無限タップを防ぐため、1回目までのみカウント
                withAnimation(.easeOut(duration: fadeIn)) {
                    tapCount += 1
                }
            }
        }
    }
}

#Preview {
    MatchStartView()
}


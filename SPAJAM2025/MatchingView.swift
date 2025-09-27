//
//  MatchingView.swift
//  SPAJAM2025
//
//  Created by すさきひとむ on 2025/09/27.
//

import SwiftUI

struct MatchingView : View {
    
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack{
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
                }.padding(.top)
                
                Spacer()
                
                VStack(spacing: 50) { // ★ テキストとローディングの間隔を50に設定
                    
                    VStack{
                        Text("夜空を眺める人を募集中...")
                            .foregroundColor(.white)
                            .font(.system(size: 33))
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Text("星を見ると心が落ち着くよね")
                            .foregroundColor(.gray.opacity(0.7))
                            .font(.title)
                            .padding(.bottom,50)
                    }
                    
                    // ローディングの円（くるくる）
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 0.7, green: 0.7, blue: 0.8)))
                    //ここでサイズ変更
                        .scaleEffect(6.0) // 以前より少し大きく見せるためにスケールを調整
                }
                .offset(y:-60)
                
                Spacer()
                
               
                
                Button {
                  dismiss()
                    
                } label: {
                    Text("キャンセル")
                        .font(.headline)
                        .frame(width: 250)
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(32)
                        .shadow(color: .black.opacity(0.4) ,radius: 3, x: 0, y: 4)
                       
                }.padding(.bottom)

                
            }
        }
    }
}

#Preview{
    MatchingView()
}

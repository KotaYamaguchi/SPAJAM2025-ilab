//
//  MatchingView.swift
//  SPAJAM2025
//
//  Created by すさきひとむ on 2025/09/27.
//

import SwiftUI

struct MatchingView : View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var gameCenterManager: GameCenterManager
    @State private var isMatchingComplete = false
    
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
            
            GeometryReader { geometry in
                StarrySkyView(
                    starCount: 200,
                    width: geometry.size.width,
                    height: geometry.size.height,
                    seed: 12345
                )
            }
            
            VStack(spacing: 0){

                HStack {
                    Spacer()
                    Image(systemName: "moon.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.yellow)
                        .opacity(0.6)
                        .padding(.trailing, 43)
                }.padding(.top)
                
                Spacer()
                
                VStack(spacing: 50) {
                    
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
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white/*Color(red: 0.7, green: 0.7, blue: 0.8)*/))
                        .scaleEffect(2.0)
                }
                .offset(y:-60)
                
                Spacer()
                
                Button {
                    // マッチングをキャンセル
                    gameCenterManager.disconnectFromMatch()
                    // 画面を閉じる
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
                }
                .padding(.bottom)
            }
        }
        .onAppear {
            // 認証とマッチング開始
            if !gameCenterManager.isAuthenticated {
                gameCenterManager.authenticatePlayer { isAuthenticated in
                    if isAuthenticated {
                        gameCenterManager.startMatchmaking()
                    }
                }
            } else {
                gameCenterManager.startMatchmaking()
            }
        }
        .onChange(of: gameCenterManager.currentMatch) { oldValue, newValue in
            // マッチングが成功したら画面遷移
            if newValue != nil {
                isMatchingComplete = true
            }
        }
        .fullScreenCover(isPresented: $isMatchingComplete) {
            MatchingEnd()
                .environmentObject(gameCenterManager)
        }
        .onDisappear {
            // マッチングが成功せずに画面が閉じる場合のみ、切断処理を呼ぶ
            if !isMatchingComplete {
                gameCenterManager.disconnectFromMatch()
            }
        }
    }
}

#Preview{
    MatchingView()
        .environmentObject(GameCenterManager())
}

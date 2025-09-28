//
//  StarHidingView.swift
//  SPAJAM2025
//
//  Created by Kota Yamaguchi on 2025/09/27.
//

import SwiftUI

struct StarHidingView: View {
    @Binding var currentView: PublisherViewIdentifier
    @EnvironmentObject var gameCenterManager: GameCenterManager
    
    @StateObject private var starLoader = StarLoader()
    
    // 選択/作成した星を保持する
    @State private var createdStar: UserStar? = nil
    // 選択をロックするための状態変数
    @State private var isLocked = false
    
    var body: some View {
        ZStack{
            // isLockedとcreatedStarをStarGazingViewに渡す
            StarGazingView(userStar: $createdStar, stars: $starLoader.stars, isLocked: $isLocked)
            
            if !isLocked {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            VStack{
                Spacer()
                
                if isLocked {
                    Text("相手に星を送りました！")
                        .foregroundStyle(.white)
                        .font(.title3)
                        .padding()
                } else {
                    Text(createdStar == nil ? "タップで星を隠してください" : "ZUBOSHIボタンで決定！")
                        .foregroundStyle(.white)
                        .font(.title3)
                        .padding()
                }
                
                Spacer()
                
                Button{
                    AudioManager.shared.playSFX("SEButton")
                    // 作成した星の座標を送信する
                    if let star = createdStar {
                        gameCenterManager.sendStarAzimuthAltitude(azimuth: star.azimuth, altitude: star.altitude)
                        isLocked = true // 送信したらロックする
                        
                        // 2秒後に次のビューに遷移
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                            currentView = .receiveQuestion
//                        }
                    }
                    
                } label: {
                    Text("ZUBOSHIにする")
                }
                .buttonStyle(.customThemed(backgroundColor: .white, foregroundColor: .black,width: 200))
                // isLockedがtrue、または星がまだ作成されていない場合はボタンを無効化
                .disabled(isLocked || createdStar == nil)
            }
        }
    }
}

#Preview{
    PublisherGameView()
        .environmentObject(GameCenterManager())
}

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
    @State private var isShowingMatchingView = false
    
    //アニメーションの速度
    let fadeIn : Double = 1.0
    
    var body: some View {
        NavigationStack{
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
                        Image("moon")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.yellow)
                            .opacity(0.6)
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
                                .font(.system(.title, design: .serif))
                            
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
                        
                        Button {
                            AudioManager.shared.stopBGM()
                            AudioManager.shared.playSFX("SEButton")
                            AudioManager.shared.playBGM("マッチングbgm")
                            isShowingMatchingView = true
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
            }
            .onTapGesture {
                if tapCount < 1 {
                    withAnimation(.easeOut(duration: fadeIn)) {
                        tapCount += 1
                    }
                }
            }
            .fullScreenCover(isPresented: $isShowingMatchingView) {
                MatchingView()
                    
            }
        }
    }
}

#Preview {
    MatchStartView()
}

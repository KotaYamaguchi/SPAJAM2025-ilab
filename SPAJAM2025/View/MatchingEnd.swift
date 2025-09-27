//
//  MatchingEnd.swift
//  SPAJAM2025
//
//  Created by すさきひとむ on 2025/09/27.
//

import SwiftUI

struct MatchingEnd: View {
    
    @StateObject private var loader = StarLoader()
    
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
                // 画面全体に広げる
                .ignoresSafeArea()
                
                GeometryReader { geometry in
                    
                    
                    StarrySkyView(
                        starCount: 200,
                        width: geometry.size.width,
                        height: geometry.size.height,
                        seed: 12345 // 固定シードで毎回同じ星空
                    )
                }
                
                
                VStack(spacing: 0){
                    
                    HStack {
                        Spacer()
                        // 三日月アイコン（SF Symbolsを使用）
                        Image(systemName: "moon.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.yellow)
                            .opacity(0.6)
                            .padding(.trailing, 43)
                    }
                    .padding(.top)
                    
                    Spacer()
                    
                    Text("マッチングしました！")
                        .padding(.bottom,30)
                        .font(.system(size:35))
                        .foregroundColor(.white)
                        .transition(.opacity)
                    
                    NavigationLink {
                                    StarGazingView(stars: $loader.stars)
                                        } label: {
                                            Text("星空を眺める")
                                                .font(.headline)
                                                .frame(width: 250)
                                                .padding()
                                                .background(Color.white.opacity(0.2))
                                                .foregroundColor(.white)
                                                .cornerRadius(32)
                                        }
                    
                    Spacer()
                    
                    
                }
            }
        }
    }
}

#Preview {
    MatchingEnd()
}



//
//  TitleView.swift
//  SPAJAM2025
//
//  Created by Kota Yamaguchi on 2025/09/27.
//

import SwiftUI
//タイトル画面です．
struct TitleView: View {
    var body: some View {
        Text("SPAJAM2025")
            .font(.largeTitle)
            .bold()
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
        
        NavigationLink{
            MatchingView()
        }label: {
            Text("ゲームを始める")
        }
    }
}

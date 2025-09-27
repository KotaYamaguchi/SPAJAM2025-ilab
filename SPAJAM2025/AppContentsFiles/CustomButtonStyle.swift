//
//  CustomButtonStyle.swift
//  SPAJAM2025
//
//  Created by Kota Yamaguchi on 2025/09/27.
//


import SwiftUI

struct CustomThemedButtonStyle: ButtonStyle {
    
    // 💡 引数として受け取りたいプロパティを定義
    var backgroundColor: Color
    var foregroundColor: Color
    
    // ButtonStyleプロトコルの必須メソッド
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .font(.headline)
            .frame(width: 250)
            .padding()
            // 💡 引数で渡された backgroundColor を使用
            .background(backgroundColor.opacity(0.8)) // 不透明度(0.8)は元のスタイルを参考に残しています
            // 💡 引数で渡された foregroundColor を使用
            .foregroundColor(foregroundColor)
            .cornerRadius(32)
            .shadow(color: .black.opacity(0.4) ,radius: 3, x: 0, y: 4)
            
            // 押された時の視覚的なフィードバック (オプション)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

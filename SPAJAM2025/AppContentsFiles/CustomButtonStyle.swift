//
//  CustomButtonStyle.swift
//  SPAJAM2025
//
//  Created by Kota Yamaguchi on 2025/09/27.
//


import SwiftUI

struct CustomCancelButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        // configuration.label は Button { ... } label: { ここ } の部分
        configuration.label
            // 提供されたコードのモディファイアを適用
            .font(.headline)
            .frame(width: 250)
            .padding()
            .background(Color.black.opacity(0.3))
            .foregroundColor(.white)
            .cornerRadius(32)
            .shadow(color: .black.opacity(0.4) ,radius: 3, x: 0, y: 4)
            // ボタンが押された時の視覚的なフィードバックを追加（オプション）
            // isPressed が true の時、不透明度を少し下げて押されている感を出します
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            // アニメーションを滑らかにする（オプション）
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == CustomCancelButtonStyle {
    // .customCancel のように呼び出せるようになります
    static var customCancel: CustomCancelButtonStyle {
        CustomCancelButtonStyle()
    }
}


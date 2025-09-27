//
//  CustomButtonStyle.swift
//  SPAJAM2025
//
//  Created by Kota Yamaguchi on 2025/09/27.
//


import SwiftUI

struct CustomThemedButtonStyle: ButtonStyle {
    
    // 💡 新しく横幅のプロパティを追加
    var buttonWidth: CGFloat?
    var backgroundColor: Color
    var foregroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .font(.headline)
            // 💡 追加した buttonWidth を使用
            .frame(width: buttonWidth)
            .padding()
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(32)
            .shadow(color: .black.opacity(0.4) ,radius: 3, x: 0, y: 4)
            
            // 押された時の視覚的なフィードバック (オプション)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == CustomThemedButtonStyle {
    static func customThemed(
        backgroundColor: Color,
        foregroundColor: Color,
        // 💡 buttonWidth にデフォルト値 250 を設定
        width buttonWidth: CGFloat? = 250
    ) -> CustomThemedButtonStyle {
        CustomThemedButtonStyle(
            buttonWidth: buttonWidth,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor
        )
    }
}

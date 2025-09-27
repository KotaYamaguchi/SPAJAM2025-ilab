//
//  StarrySkyView.swift
//  SPAJAM2025
//
//  Created by すさきひとむ on 2025/09/27.
//

import SwiftUI

// MARK: - シード付き乱数ジェネレータ
struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) { self.state = seed }
    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}

// MARK: - 星モデル
struct Star: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let baseOpacity: Double
}

// MARK: - 星空ビュー
struct StarrySkyView: View {
    private let stars: [Star]
    @State private var flicker = false
    @State private var showMeteor = false
    @State private var meteorStart: CGSize = .zero
    @State private var meteorEnd: CGSize = .zero
    @State private var meteorAngle: Angle = .degrees(-20)
    
    let width: CGFloat
    let height: CGFloat
    
    init(starCount: Int = 100, width: CGFloat, height: CGFloat, seed: UInt64 = 12345) {
        self.width = width
        self.height = height
        
        var rng = SeededGenerator(seed: seed)
        var tempStars: [Star] = []
        
        for _ in 0..<starCount {
            tempStars.append(
                Star(
                    x: CGFloat.random(in: 0...width, using: &rng),
                    y: CGFloat.random(in: 0...height * 0.8, using: &rng),
                    size: CGFloat.random(in: 1...3, using: &rng),
                    baseOpacity: Double.random(in: 0.3...0.8, using: &rng)
                )
            )
        }
        self.stars = tempStars
    }
    
    var body: some View {
        ZStack {
            // 星空
            ForEach(stars) { star in
                Circle()
                    .fill(Color.white)
                    .frame(width: star.size, height: star.size)
                    .opacity(flicker ? star.baseOpacity * 0.5 : star.baseOpacity)
                    .position(x: star.x, y: star.y)
                    .animation(.easeInOut(duration: Double.random(in: 1...3)), value: flicker)
            }
            
            // 流れ星
            if showMeteor {
                Capsule()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.white, Color.clear]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(width: 120, height: 2)
                    .offset(meteorStart)
                    .rotationEffect(meteorAngle)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.5)) {
                            meteorStart = meteorEnd
                        }
                    }
            }
        }
        .onAppear {
            // 点滅アニメーション
            withAnimation(.easeInOut(duration: 2).repeatForever()) {
                flicker.toggle()
            }
            
            // 流れ星を周期的に出す
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                spawnMeteor()
            }
        }
    }
    
    private func spawnMeteor() {
        // ランダム角度（-60°〜-20°くらい）
        let angle = Double.random(in: -70 ... -20)
        meteorAngle = .degrees(angle)
        
        // 画面のランダムなスタート位置（上か横から出現）
        let startX = CGFloat.random(in: 0...width)
        let startY = CGFloat.random(in: 0...height * 0.3) // 上の方に出やすくする
        meteorStart = CGSize(width: startX, height: startY)
        
        // 終点（角度に沿って長めに移動）
        meteorEnd = CGSize(
            width: startX + CGFloat(cos(angle * .pi/180)) * -500,
            height: startY + CGFloat(sin(angle * .pi/180)) * -500
        )
        
        // 出現
        showMeteor = true
        
        // 消す処理
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showMeteor = false
        }
    }
}

//
//  ReceiverFindingView.swift
//  SPAJAM2025
//
//  Created by Kota Yamaguchi on 2025/09/27.
//

import SwiftUI

struct ReceiverFindingView: View {
    @StateObject private var starLoader = StarLoader()
    var body: some View {
        ZStack{
            //ARが表示されます
            StarGazingView(stars:$starLoader.stars)
            //プレイ画面のUI
            ReceiverQuestionView()
        }
    }
}

#Preview {
    ReceiverGameView()
}

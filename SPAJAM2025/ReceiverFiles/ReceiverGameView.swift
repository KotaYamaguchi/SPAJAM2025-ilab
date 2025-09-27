//
//  ReceiverGameView.swift.swift
//  SPAJAM2025
//
//  Created by Kota Yamaguchi on 2025/09/27.
//

import SwiftUI
//回答者側のゲームプレイ画面です．
struct ReceiverGameView: View {
    @State private var currentView:ReceiverViewIdentifier = .finding
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
            switch currentView {
            case .finding:
                ReceiverFindingView()
            case .result:
                ReceiverResultView()
            }
        }
        
    }
}

enum ReceiverViewIdentifier: String{
    case finding
    case result
}







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
        switch currentView {
        case .question:
            ReceiverQuestionView()
        case .finding:
            ReceiverFindingView()
        case .result:
            ReceiverResultView()
        }
        
        
    }
}

enum ReceiverViewIdentifier: String{
    case question
    case finding
    case result
}







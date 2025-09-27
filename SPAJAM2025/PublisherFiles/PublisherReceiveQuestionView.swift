//
//  PublisherQuestionView.swift
//  SPAJAM2025
//
//  Created by Kota Yamaguchi on 2025/09/27.
//

import SwiftUI

struct PublisherReceiveQuestionView: View {
    @State private var isLier: Bool = false
    @State private var showRespondMessage: Bool = false
    @State private var respondMessage: String = ""
    var body: some View {
        VStack{
            Text("質問が届きました")
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 300,height: 100)
                    .foregroundStyle(.white)
                    .shadow(radius: 10)
                Text("オリオン座の近くにありますか？")
            }
            if showRespondMessage{
                respondingQuestion()
            }else{
                answerQuestionButton()
            }
        }
    }
    @ViewBuilder func answerQuestionButton() -> some View {
        VStack{
            HStack{
                Button{
                    respondMessage = "バレないようにね..."
                    isLier = true
                    showRespondMessage = true
                }label:{
                    Text("嘘をつく")
                        .padding()
                }
                
                Button{
                    respondMessage = "正直が一番だよね..."
                    isLier = false
                    showRespondMessage = true
                }label:{
                    Text("正直に答える")
                        .padding()
                }
                
            }
        }
    }
    @ViewBuilder func respondingQuestion() -> some View {
        Text(respondMessage)
            .font(.title)
    }
}

#Preview {
    PublisherReceiveQuestionView()
}

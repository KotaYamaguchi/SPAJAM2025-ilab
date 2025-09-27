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
        ZStack{
            VStack{
                Text("質問が届きました")
                    .foregroundStyle(.white)
                    .font(.system(size: 20))
                ZStack{
                    RoundedRectangle(cornerRadius: 50)
                        .frame(maxWidth: 350,maxHeight: 100)
                        .foregroundStyle(.white)
                        .shadow(radius: 10)
                    Text("オリオン座の近くにありますか？")
                        .font(.system(size: 20))
                }
                Spacer()
                if showRespondMessage{
                    respondingQuestion()
                    Spacer()
                }else{
                    answerQuestionButton()
                }
            }
            .padding(.vertical,60)
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
                }
                .buttonStyle(.customThemed(backgroundColor: .blue, foregroundColor: .white,width: 100))
                
                Button{
                    respondMessage = "正直が一番だよね..."
                    isLier = false
                    showRespondMessage = true
                }label:{
                    Text("正直に答える")
                }
                .buttonStyle(.customThemed(backgroundColor: .green, foregroundColor: .white,width: 100))
            }
        }
    }
    @ViewBuilder func respondingQuestion() -> some View {
        VStack{
            Spacer()
            Text(respondMessage)
                .font(.system(size: 20))
            Spacer()
            Button{
                showRespondMessage = false
            }label: {
                Text("答え終わった")
            }
            .buttonStyle(.customThemed(backgroundColor: .white, foregroundColor: .black,width: 100))
        }
    }
}

#Preview {
    PublisherReceiveQuestionView()
}

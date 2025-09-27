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
    
    @State private var canLieCount: Int = 2
    
    @State private var questionText: String = "オリオン座の近くにありますか？"
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
                    Text(questionText)
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
    
    @ViewBuilder
    func answerQuestionButton() -> some View {
        VStack{
            HStack{
                ZStack(alignment:.topTrailing){
                    Button{
                        respondMessage = "バレないようにね..."
                        isLier = true
                        showRespondMessage = true
                        // 回数を減らす。ただし0以下にはしない
                        if canLieCount > 0 {
                            canLieCount = max(0, canLieCount - 1)
                        }
                    }label:{
                        Text("嘘をつく")
                    }
                    .buttonStyle(.customThemed(
                        backgroundColor: canLieCount > 0 ? .blue : .gray.opacity(0.5),
                        foregroundColor: .white,
                        width: 100)
                    )
                    .disabled(canLieCount == 0)
                    
                    Text("\(canLieCount)回")
                        .padding(10)
                        .background{
                            RoundedRectangle(cornerRadius: 50)
                                .foregroundStyle(.white)
                        }
                        .offset(x:10,y:-10)
                        .shadow(radius: 5)
                        
                }
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
    
    @ViewBuilder
    func respondingQuestion() -> some View {
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

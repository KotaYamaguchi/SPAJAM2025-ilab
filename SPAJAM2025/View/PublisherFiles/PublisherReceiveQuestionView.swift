//
//  answerQuestionButtonを押した後，「はい」「いいえ」を選択するボタンを表示する．ボタンを押すと，相手ユーザーにどちらを選んだかを送信する．
//  SPAJAM2025
//  このUIを実装してください．
//  Created by Kota Yamaguchi on 2025/09/27.
//

import SwiftUI

struct PublisherReceiveQuestionView: View {
    @State private var isLier: Bool = false
    @State private var showRespondMessage: Bool = false
    @State private var respondMessage: String = ""
    @State private var canLieCount: Int = 2
    @State private var questionText: String = "オリオン座の近くにありますか？"
    @State private var showYesNoButtons: Bool = false
    
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
                        showYesNoButtons = true
                        // 回数はここで減らさない
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
                    showYesNoButtons = true
                }label:{
                    Text("正直に答える")
                }
                .buttonStyle(.customThemed(backgroundColor: .green, foregroundColor: .white,width: 100))
            }
        }
    }
    
    @ViewBuilder
    func respondingQuestion() -> some View {
        VStack {
            Spacer()
            Text(respondMessage)
                .font(.system(size: 20))
                .padding(.bottom, 30)
            
            if showYesNoButtons {
                VStack(spacing: 16) {
                    HStack(spacing: 30) {
                        Button {
                            if isLier && canLieCount > 0 {
                                canLieCount = max(0, canLieCount - 1)
                            }
                            sendAnswerToOpponent(answer: "はい", isLie: isLier)
                            resetToInitial()
                        } label: {
                            Text("はい")
                                .frame(width: 90, height: 44)
                                .font(.title2)
                        }
                        .buttonStyle(.customThemed(backgroundColor: .blue, foregroundColor: .white, width: 90))
                        
                        Button {
                            if isLier && canLieCount > 0 {
                                canLieCount = max(0, canLieCount - 1)
                            }
                            sendAnswerToOpponent(answer: "いいえ", isLie: isLier)
                            resetToInitial()
                        } label: {
                            Text("いいえ")
                                .frame(width: 90, height: 44)
                                .font(.title2)
                        }
                        .buttonStyle(.customThemed(backgroundColor: .pink, foregroundColor: .white, width: 90))
                    }
                    
                    // × ボタン（はい・いいえボタンの下中央）
                    Button(action: {
                        // 一つ前（嘘をつく・正直に答えるボタン画面）へ戻す
                        showRespondMessage = false
                        showYesNoButtons = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                            .frame(width: 32, height: 32)
                            .background(Circle().foregroundColor(.white))
                            .shadow(radius: 2)
                    }
                    .padding(.top, 8)
                }
            }
            Spacer()
        }
    }
    
    func sendAnswerToOpponent(answer: String, isLie: Bool) {
        // TODO: 実際の通信処理に置き換える
        print("相手に送信: 答え=\(answer), 嘘=\(isLie ? "YES" : "NO")")
    }
    
    func resetToInitial() {
        showRespondMessage = false
        showYesNoButtons = false
        respondMessage = ""
    }
}

#Preview {
    PublisherReceiveQuestionView()
}

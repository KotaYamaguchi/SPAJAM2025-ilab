import SwiftUI

struct PublisherReceiveQuestionView: View {
    // MARK: - 追加①: GameCenterManagerを環境オブジェクトとして利用
    @EnvironmentObject var gameCenterManager: GameCenterManager

    // MARK: - 変更点①: 親Viewからデータを受け取るプロパティ
    let questionText: String
    @Binding var currentView: PublisherViewIdentifier

    @State private var isLier: Bool = false
    @State private var showRespondMessage: Bool = false
    @State private var respondMessage: String = ""
    @State private var canLieCount: Int = 2
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
                        .padding()
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
            Button{
                showRespondMessage = true
            }label: {
                Text("回答する")
            }
            .buttonStyle(.customThemed(backgroundColor: .white, foregroundColor: .black,width: 200))
        }
    }
    @ViewBuilder
    func respondingQuestion() -> some View {
        VStack(spacing: 20) {
            Text(respondMessage)
                .foregroundStyle(.white)
                .font(.system(size: 20))
            
            HStack(spacing: 30) {
                Button {
                    isLier = true
                    respondMessage = "嘘をついて答える"
                    showYesNoButtons = true
                } label: {
                    Text("嘘をつく")
                }
                .buttonStyle(.customThemed(backgroundColor: .white, foregroundColor: .black, width: 140))
                .disabled(canLieCount <= 0)
                
                Button {
                    isLier = false
                    respondMessage = "正直に答える"
                    showYesNoButtons = true
                } label: {
                    Text("正直に答える")
                }
                .buttonStyle(.customThemed(backgroundColor: .white, foregroundColor: .black, width: 140))
            }
            .padding(.horizontal)
            
            if showYesNoButtons {
                VStack(spacing: 16) {
                    HStack(spacing: 30) {
                        Button {
                            if isLier && canLieCount > 0 {
                                canLieCount = max(0, canLieCount - 1)
                            }
                            sendAnswerToOpponent(answer: "はい", isLie: isLier)
                            resetToInitial()
                            currentView = .starHiding
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
                            currentView = .starHiding
                        } label: {
                            Text("いいえ")
                                .frame(width: 90, height: 44)
                                .font(.title2)
                        }
                        .buttonStyle(.customThemed(backgroundColor: .pink, foregroundColor: .white, width: 90))
                    }
                    
                    Button(action: {
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
    
    // MARK: - 変更点
    // GameCenterManager経由で回答を送信する
    func sendAnswerToOpponent(answer: String, isLie: Bool) {
        gameCenterManager.sendGameInfoFromPublisher(answer: answer, isLiar: isLie, isAnswered: true)
        print("相手に送信: 答え=\(answer), 嘘=\(isLie ? "YES" : "NO")")
    }
    
    func resetToInitial() {
        showRespondMessage = false
        showYesNoButtons = false
        respondMessage = ""
    }
}

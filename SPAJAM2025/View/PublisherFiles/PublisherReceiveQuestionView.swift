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
                AudioManager.shared.playSFX("SEButton")
                showRespondMessage = true
            }label: {
                Text("回答する")
                    .font(.headline)
                    .frame(width: 200)
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(32)
                    .shadow(color: .black.opacity(0.4) ,radius: 3, x: 0, y: 4)
            }
            //.buttonStyle(.customThemed(backgroundColor: .white, foregroundColor: .black,width: 200))
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
                    AudioManager.shared.playSFX("SEButton")
                    isLier = true
                    respondMessage = "嘘をついて答える"
                    showYesNoButtons = true
                } label: {
                    Text("嘘をつく")
                        .font(.headline)
                        .frame(width: 140)
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(32)
                        .shadow(color: .black.opacity(0.4) ,radius: 3, x: 0, y: 4)
                }
                //.buttonStyle(.customThemed(backgroundColor: .white, foregroundColor: .black, width: 140))
                .disabled(canLieCount <= 0)
                
                Button {
                    AudioManager.shared.playSFX("SEButton")
                    isLier = false
                    respondMessage = "正直に答える"
                    showYesNoButtons = true
                } label: {
                    Text("正直に答える")
                        .font(.headline)
                        .frame(width: 140)
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(32)
                        .shadow(color: .black.opacity(0.4) ,radius: 3, x: 0, y: 4)
                }
                //.buttonStyle(.customThemed(backgroundColor: .white, foregroundColor: .black, width: 140))
            }
            .padding(.horizontal)
            
            if showYesNoButtons {
                VStack(spacing: 16) {
                    HStack(spacing: 30) {
                        Button {
                            AudioManager.shared.playSFX("SEButton")
                            if isLier && canLieCount > 0 {
                                canLieCount = max(0, canLieCount - 1)
                            }
                            sendAnswerToOpponent(answer: "はい", isLie: isLier)
                            resetToInitial()
                            currentView = .gamePlay
                        } label: {
                            Text("はい")
                                .frame(width: 90, height: 44)
                                .font(.title2)
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(32)
                                .shadow(color: .black.opacity(0.4) ,radius: 3, x: 0, y: 4)
                        }
                        //.buttonStyle(.customThemed(backgroundColor: .blue, foregroundColor: .white, width: 90))
                        
                        Button {
                            AudioManager.shared.playSFX("SEButton")
                            if isLier && canLieCount > 0 {
                                canLieCount = max(0, canLieCount - 1)
                            }
                            sendAnswerToOpponent(answer: "いいえ", isLie: isLier)
                            resetToInitial()
                            currentView = .gamePlay
                        } label: {
                            Text("いいえ")
                                .frame(width: 90, height: 44)
                                .font(.title2)
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(32)
                                .shadow(color: .black.opacity(0.4) ,radius: 3, x: 0, y: 4)
                        }
                        //.buttonStyle(.customThemed(backgroundColor: .pink, foregroundColor: .white, width: 90))
                    }
                    
                    Button(action: {
                        AudioManager.shared.playSFX("SEButton")
                        showRespondMessage = false
                        showYesNoButtons = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(Circle().foregroundColor(.white))
                            .shadow(color: .black.opacity(0.4) ,radius: 3, x: 0, y: 4)
                        
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

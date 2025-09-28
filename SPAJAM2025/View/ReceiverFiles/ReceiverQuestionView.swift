import SwiftUI

struct ReceiverQuestionView: View {
    @ObservedObject var viewModel: ReceiverGameViewModel
    
    @EnvironmentObject var gameCenterManager: GameCenterManager
    
    @State private var isExpandQuesitions: Bool = false
    @State private var isSelectedStar: Bool = false
    @State private var displayedQuestions: [String] = []
    
    // MARK: - 追加①: Publisherの返答を表示するためのState変数
    @State private var publisherAnswer: String? = nil
    
    let questions: [String] = [
        "空の真上に近い位置に見えますか？",
        "北の空に見えますか？",
        "東の空に見えますか？",
        "オリオン座の近くにありますか？",
        "北斗七星の近くにありますか？",
        "天の川の近くにありますか？",
        "太陽系の惑星の近くにありますか？",
        "地平線から30度以下の低い位置に見えますか？",
        "目で見える最も明るい星と近いですか？",
        "近くに，赤やオレンジ色に見える星がありますか？",
        "金星や木星と近くにありますか？",
    ]
    
    var body: some View {
        ZStack { // ZStackを追加してオーバーレイを可能に
            if let guessedStarName = viewModel.guessedStar?.name {
                Text("選択中の星: \(guessedStarName)")
                    .foregroundColor(.green)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.bottom, 5)
            }
            
            // 推測結果のフィードバックを表示
            if !viewModel.lastGuessResult.isEmpty {
                Text(viewModel.lastGuessResult)
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .transition(.opacity)
                    .onAppear {
                        // 2秒後にメッセージを消す
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            viewModel.lastGuessResult = ""
                        }
                    }
                
            }
            VStack {
                Spacer()
                if isExpandQuesitions {
                    questionList()
                } else {
                
                    actionButtons()
                }
            }
            // MARK: - 追加②: 返答を表示するオーバーレイUI
            if let answer = publisherAnswer {
                answerOverlayView(answer: answer)
            }
        }
        // MARK: - 追加③: GameCenterManagerからのデータ受信を監視
        .onReceive(gameCenterManager.$lastReceivedGameInfoFromPublisher) { gameInfo in
            guard let info = gameInfo, info.isAnswered else { return }
            
            // 回答を表示
            self.publisherAnswer = info.answer
            
            // 3秒後に回答を非表示にする
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.publisherAnswer = nil
            }
        }
    }
    
    // MARK: - 追加④: Publisherの返答を表示するためのView
    @ViewBuilder
    private func answerOverlayView(answer: String) -> some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            
            VStack {
                Text("相手の返事")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(answer)
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(answer == "はい" ? .cyan : .pink)
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 5)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Material.ultraThin)
            )
            .transition(.scale.combined(with: .opacity))
        }
        .zIndex(10) // 他のUIより手前に表示
    }
    
    private func selectRandomQuestions() {
        displayedQuestions = questions.shuffled().prefix(3).map { $0 }
    }
    
    @ViewBuilder func questionList() -> some View {
        VStack(spacing:10){
            ForEach(displayedQuestions, id: \.self) { question in
                Button{
                    viewModel.selectedQuestion = question
                    // Game Center経由で質問内容を送信
                    gameCenterManager.sendGameInfoFromReceiver(selectedQuestion: question, isPushedAnswer: false)
                    print("質問を送信: \(question)")
                    withAnimation { isExpandQuesitions = false }
                } label: {
                    Text(question)
                        .font(.headline)
                        .frame(width: 250)
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(32)
                        .shadow(color: .black.opacity(0.4) ,radius: 3, x: 0, y: 4)
                }
                //.buttonStyle(.customThemed(backgroundColor: .white, foregroundColor: .black))
            }
        }
    }

    
    @ViewBuilder func actionButtons() -> some View {
        VStack{
            Button{
                selectRandomQuestions()
                withAnimation { isExpandQuesitions = true }
            }label: {
                Text("質問する")
                    .font(.headline)
                    .frame(width: 250)
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(32)
                    .shadow(color: .black.opacity(0.4) ,radius: 3, x: 0, y: 4)
            }
            //.buttonStyle(.customThemed(backgroundColor: .white, foregroundColor: .black))
            
            Button{
                // 回答ボタンを押した場合の送信も必要ならここで送る
                withAnimation { isExpandQuesitions = false }
                
                viewModel.checkGuess()
            }label: {
                Text("ZUBARI！")
                    .font(.headline)
                    .frame(width: 250)
                    .padding()
                    .background(Color.yellow.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(32)
                    .shadow(color: .yellow.opacity(0.4) ,radius: 3, x: 0, y: 4)
            }
            //.buttonStyle(.customThemed(backgroundColor: .yellow, foregroundColor: .black))
            .disabled(viewModel.guessedStar == nil) // 星が選択されていない場合は無効
            .padding(.bottom, 30)
        }
    }
}

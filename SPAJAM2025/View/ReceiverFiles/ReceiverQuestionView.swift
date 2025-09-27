import SwiftUI

struct ReceiverQuestionView: View {
    @ObservedObject var viewModel: ReceiverGameViewModel
    @State private var isExpandQuesitions: Bool = false
    @State private var isSelectedStar: Bool = false
    @State private var displayedQuestions: [String] = []

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
        VStack {
            Spacer()
            if isExpandQuesitions {
                questionList()
            } else {
                if isSelectedStar {
                    answerButton()
                }
                askButton()
            }
        }
    }

    private func selectRandomQuestions() {
        displayedQuestions = questions.shuffled().prefix(3).map { $0 }
    }

    @ViewBuilder func questionList() -> some View {
        VStack(spacing:10){
            ForEach(displayedQuestions, id: \.self) { question in
                Button {
                    viewModel.selectedQuestion = question
                    print("質問を送信: \(question)")
                    viewModel.sendSelectedQuestion() // ここで送信
                    withAnimation { isExpandQuesitions = false }
                } label: {
                    Text(question)
                }
                .buttonStyle(.customThemed(backgroundColor: .white, foregroundColor: .black))
            }
            Button{
                withAnimation { isExpandQuesitions = false }
                viewModel.sendSelectedStarInfo() // ここで送信
            }label: {
                Image(systemName: "xmark")
            }
            .buttonStyle(.customThemed(backgroundColor: .white, foregroundColor: .black, width: 30))
        }
    }

    @ViewBuilder func askButton() -> some View {
        Button{
            selectRandomQuestions()
            withAnimation { isExpandQuesitions = true }
        }label: {
            Text("質問する")
        }
        .buttonStyle(.customThemed(backgroundColor: .white, foregroundColor: .black))
    }

    @ViewBuilder func answerButton() -> some View {
        Button{
            viewModel.isPushedAnswer = true
        }label: {
            Text("ZUBARI！")
        }
        .buttonStyle(.customThemed(backgroundColor: .yellow, foregroundColor: .black))
    }
}

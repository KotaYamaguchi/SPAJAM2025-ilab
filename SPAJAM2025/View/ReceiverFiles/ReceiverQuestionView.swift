import SwiftUI

struct ReceiverQuestionView: View {
    @ObservedObject var viewModel: ReceiverGameViewModel

    var body: some View {
        VStack {
            Spacer()
            
            // 選択中の星の名前を表示
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
            
            // ZUBARIボタン
            Button{
                viewModel.checkGuess()
            }label: {
                Text("ZUBARI！")
            }
            .buttonStyle(.customThemed(backgroundColor: .yellow, foregroundColor: .black))
            .disabled(viewModel.guessedStar == nil) // 星が選択されていない場合は無効
            .padding(.bottom, 30)
        }
    }
}

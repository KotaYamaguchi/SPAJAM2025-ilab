import SwiftUI

struct ReceiverResultView: View {
    @ObservedObject var viewModel: ReceiverGameViewModel

    private let offscreenOffset: CGFloat = 400

    var body: some View {
        VStack{
            ZStack{
                if viewModel.isCorrectAnswer {
             
                } else {
                   
                }
            }
        }
        // ビューが表示されたときにアニメーションを開始
        .onAppear {
            // アニメーションや判定結果のセットはViewModelで管理するのが望ましい
        }
    }
}

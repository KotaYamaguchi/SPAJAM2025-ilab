import SwiftUI

struct ReceiverResultView: View {
    @ObservedObject var viewModel: ReceiverGameViewModel

    private let offscreenOffset: CGFloat = 400

    var body: some View {
        VStack{
            ZStack{
                if viewModel.isCorrectAnswer {
                    Group{
                        Image("ZUBOSHI_logo_mask")
                            .resizable()
                            .brightness(0)
                            .scaleEffect(2.0)
                            .brightness(0.4)
                            .mask {
                                Text("ZUBOSHI")
                                    .blur(radius: 1)
                                    .shadow(radius: 10)
                                    .font(.system(size: 80, weight: .black))
                            }
                    }
                    .frame(width: 500)
                    .scaleEffect(viewModel.isCorrectAnswer ? 1.0 : 100.0)
                    .ignoresSafeArea()
                } else {
                    Group{
                        Image("ZUBOooN_logo_mask")
                            .resizable()
                            .brightness(0)
                            .scaleEffect(5.0)
                            .brightness(0)
                            .grayscale(1.0)
                            .mask {
                                Text("ZUBoooN...")
                                    .blur(radius: 0.5)
                                    .shadow(radius: 10)
                                    .font(.system(size: 70, weight: .black))
                            }
                    }
                    .frame(width: 500)
                    .scaleEffect(viewModel.isCorrectAnswer ? 1.0 : 100.0)
                    .rotationEffect(.degrees(viewModel.isCorrectAnswer ? 0.0 : 10.0))
                    .ignoresSafeArea()
                }
            }
        }
        // ビューが表示されたときにアニメーションを開始
        .onAppear {
            // アニメーションや判定結果のセットはViewModelで管理するのが望ましい
        }
    }
}

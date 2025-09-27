import SwiftUI

struct ReceiverFindingView: View {
    @ObservedObject var viewModel: ReceiverGameViewModel
    
    var body: some View {
        ZStack{
            //ARが表示されます
            StarGazingView(stars: $viewModel.starLoader.stars)
            //プレイ画面のUI
            ReceiverQuestionView(viewModel: viewModel)
        }
    }
}

#Preview {
    ReceiverGameView()
}

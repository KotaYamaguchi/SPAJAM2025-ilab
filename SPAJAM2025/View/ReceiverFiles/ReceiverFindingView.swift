import SwiftUI

struct ReceiverFindingView: View {
    @ObservedObject var viewModel: ReceiverGameViewModel
    
    var body: some View {
        ZStack{
            //ARが表示されます
            StarGazingView(receiverViewModel: viewModel, userStar: .constant(nil), stars: $viewModel.starLoader.stars, isLocked: .constant(false))
            //プレイ画面のUI
            ReceiverQuestionView(viewModel: viewModel)
        }
    }
}


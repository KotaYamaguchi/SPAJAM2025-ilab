import SwiftUI

struct ReceiverGameView: View {
    @StateObject private var viewModel: ReceiverGameViewModel

    init(gameCenterManager: GameCenterManager) {
        _viewModel = StateObject(wrappedValue: ReceiverGameViewModel(gameCenterManager: gameCenterManager))
    }

    var body: some View {
        ZStack{
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.1),
                    Color(red: 0.1, green: 0.1, blue: 0.25),
                    Color(red: 0.2, green: 0.4, blue: 0.5)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

                ReceiverFindingView(viewModel: viewModel)
            
        }
        .fullScreenCover(isPresented: .constant(viewModel.gameCenterManager.gameOutcome != nil)) {
            if let outcome = viewModel.gameCenterManager.gameOutcome {
                GameResultView(outcome: outcome)
                    .environmentObject(viewModel.gameCenterManager)
            }
        }
        .onAppear(perform: viewModel.reset)
    }
}


#Preview {
    ReceiverGameView(gameCenterManager: GameCenterManager())
}

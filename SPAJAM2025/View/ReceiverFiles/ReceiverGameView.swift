import SwiftUI

struct ReceiverGameView: View {
    @StateObject private var viewModel = ReceiverGameViewModel()
    
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
            switch viewModel.currentView {
            case .finding:
                ReceiverFindingView(viewModel: viewModel)
            case .result:
                ReceiverResultView(viewModel: viewModel)
            }
        }
    }
}

enum ReceiverViewIdentifier: String{
    case finding
    case result
}

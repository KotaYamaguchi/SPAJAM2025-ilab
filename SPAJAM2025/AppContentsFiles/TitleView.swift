import SwiftUI

//タイトル画面です．
struct TitleView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("SPAJAM2025")
                .font(.largeTitle)
                .bold()
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
            
            NavigationLink{
                MatchingView()
            }label: {
                Text("ゲームを始める")
            }
            .buttonStyle(.customThemed(backgroundColor: .blue, foregroundColor: .white, width: 250))
        }
    }
}

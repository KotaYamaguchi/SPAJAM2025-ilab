import SwiftUI

struct GameResultView: View {
    @EnvironmentObject var gameCenterManager: GameCenterManager
    
    let outcome: GameOutcome
    
    var body: some View {
        ZStack {
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
            
            VStack(spacing: 40) {
                if outcome == .won {
                    Text("YOU WIN!")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(.yellow)
                } else {
                    Text("YOU LOSE")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(.gray)
                }
                Button{
                    gameCenterManager.isGameFinished = true
                    gameCenterManager.disconnectFromMatch()
                }label: {
                    Text("タイトルに戻る")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(.gray)
                }
            }
            
            
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    VStack {
        GameResultView(outcome: .won).environmentObject(GameCenterManager())
        GameResultView(outcome: .lost).environmentObject(GameCenterManager())
    }
}

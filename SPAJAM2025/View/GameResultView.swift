import SwiftUI

struct GameResultView: View {
    @EnvironmentObject var gameCenterManager: GameCenterManager
    
    let outcome: GameOutcome
    
    @State private var animate:Bool = false
    @State private var incorrectRotationDegrees: Double = 0.0 // 回転角度の状態変数
    @State private var soundCount = 0
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
            
            VStack(spacing: 30) {
                if outcome == .won {
                    Group{
                        Spacer()
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
                            .onAppear {
                                if soundCount == 0{
                                    AudioManager.shared.playSFXLoud("図ボーシ",gainDB: 22)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9){
                                        AudioManager.shared.playBGM("winbgm")
                                    }
                                }else{
                                    soundCount -= 1
                                }
                            }
                        Text("あなたの勝ちです!")
                            .foregroundStyle(Color.white)
                            .font(Font.largeTitle.bold())
                        VStack{
                            Text("あなたのスコア")
                                .foregroundStyle(Color.white)
                                .font(.headline)
                                .padding(5)
                            //点数
                            Text("仮")
                                .foregroundStyle(Color.white)
                                .font(.largeTitle.bold())
                        }
                        Spacer()
                    }
                    .frame(width: 500)
                    .scaleEffect(animate ? 1.0 : 100.0)
                    .ignoresSafeArea()
                } else {
                    Group{
                        Spacer()
                        Image("ZUBOooN_logo_mask")
                            .resizable()
                            .brightness(0)
                            .scaleEffect(5.0)
                            .brightness(0)
                            .grayscale(1.0)
                            .mask {
                                Text("ZUBoooN")
                                    .blur(radius: 0.5)
                                    .shadow(radius: 10)
                                    .font(.system(size: 70, weight: .black))
                            }
                            .onAppear {
                                if soundCount == 0 {
                                    AudioManager.shared.playSFXLoud("図ボーン", gainDB: 22)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                                        AudioManager.shared.playBGM("losebgm")
                                    }
                                    soundCount += 1
                                }else {
                                    soundCount -= 1
                                }
                            }
                        Text("あなたの負けです!")
                            .foregroundStyle(Color.white)
                            .font(Font.largeTitle.bold())
                        VStack{
                            Text("あなたのスコア")
                                .foregroundStyle(Color.white)
                                .font(.headline)
                                .padding(5)
                            //点数
                            Text("仮")
                                .foregroundStyle(Color.white)
                                .font(.largeTitle.bold())
                        }
                        Spacer()
                    }
                    .frame(width: 500)
                    .scaleEffect(animate ? 1.0 : 100.0)
                    .rotationEffect(.degrees(animate ? 0.0 : 10.0))
                    .ignoresSafeArea()
                }
                Button{
                    AudioManager.shared.playSFX("SEButton")
                    gameCenterManager.isGameFinished = true
                    gameCenterManager.disconnectFromMatch()
                    
                }label: {
                    Text("タイトルに戻る")
                        .font(.headline)
                        .frame(width: 250)
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(32)
                        .shadow(color: .black.opacity(0.4) ,radius: 3, x: 0, y: 4)
                }
                //.buttonStyle(.customThemed(backgroundColor: .black, foregroundColor: .white,opacity: 0.4))
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                // 共通のスケールアニメーション
                withAnimation(.easeOut(duration: 0.3)){
                    animate = true
                }
                
                // isCorrectAnswerがfalseの場合のみ、追加の回転アニメーションを実行
                if outcome == .lost {
                    // 0.5秒後に実行
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        // withAnimationで角度の変更をアニメーションさせる
                        withAnimation(.easeInOut(duration: 0.4)) {
                            self.incorrectRotationDegrees = 40
                        }
                    }
                }
            }
            }
            .onDisappear {
                AudioManager.shared.stopBGM()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    VStack {
        GameResultView(outcome: .won).environmentObject(GameCenterManager())
        //GameResultView(outcome: .lost).environmentObject(GameCenterManager())
    }
}

import SwiftUI

struct VSView : View {
   
    @StateObject private var loader = StarLoader()
    @EnvironmentObject var gameCenterManager: GameCenterManager
    
    var body: some View {
        NavigationStack{
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
                // 画面全体に広げる
                .ignoresSafeArea()
                
                GeometryReader { geometry in
                    
                    
                    StarrySkyView(
                        starCount: 200,
                        width: geometry.size.width,
                        height: geometry.size.height,
                        seed: 12345 // 固定シードで毎回同じ星空
                    )
                }
                
                
                VStack(spacing: 10){
                    
                    HStack {
                        Spacer()
                        // 三日月アイコン（SF Symbolsを使用）
                        Image(systemName: "moon.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.yellow)
                            .opacity(0.6)
                            .padding(.trailing, 43)
                    }
                    .padding(.top)
                    
                    Spacer().frame(height: 70)
                    
                    Text("対戦成立")
                        .font(.system(size: 55))
                        .foregroundColor(.white)
                        .padding()
                        
                    Spacer().frame(height: 50)
                   
                    HStack(alignment:.center){
                        
                        Spacer()
                        
                        // 自分のアバター
                        if let avatar = gameCenterManager.localPlayerAvatar {
                            avatar
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } else {
                            // 読み込み中のプレースホルダー
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 120, height: 120)
                        }
                        
                        Spacer()
                            
                        ZStack(alignment:.center){
                           
                            Image("Vstar")
                                .resizable()
                                .foregroundColor(.yellow)
                                .frame(width: 70, height: 70)
                                .opacity(0.8)
                            
                            
                            Text("VS")
                                .offset(y:3)
                                .font(.system(size: 24))
                                .foregroundColor(.black)
                                .bold()
                                
                    }
                        
                        Spacer()
                        // 対戦相手のアバター
                        if let avatar = gameCenterManager.opponentAvatar {
                            avatar
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } else {
                            // 読み込み中のプレースホルダー
                            ProgressView()
                                .frame(width: 120, height: 120)
                                
                        }
                        
                        Spacer()
                    }
                    Spacer().frame(height: 50)
                    
                    Text("あなたは\(gameCenterManager.localPlayerRole)です")
                        .font(.system(size: 35))
                        .foregroundColor(.white)
                    
                   Spacer()
                    
                    NavigationLink{
                        GameRouterView()
                    }label: {
                        Text("開始")
                            .font(.headline)
                            .frame(width: 250)
                            .padding()
                            .background(Color.black.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(32)
                            .shadow(color: .black.opacity(0.4) ,radius: 3, x: 0, y: 4)
                        
                    }.padding(.bottom)
                }
            }
            .onAppear {
                gameCenterManager.loadLocalPlayerAvatar()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
   VSView()
}

import SwiftUI

struct StarGazingView: View {
    // 3つのViewModelをインスタンス化
    @StateObject private var motionModel = CoreMotionModel()
    @StateObject private var headingManager = HeadingManager()
    @StateObject private var locationViewModel = LocationViewModel()
    @EnvironmentObject var gameCenterManager: GameCenterManager
    @State private var opponentSelectedIndex: Int?
    @State private var ArrowAngle = Angle(degrees: 0.0)
    @State private var SelectDoubtStarPositionX: CGFloat?
    @State private var SelectDoubtStarPositionY: CGFloat?
    
    @State private var receiveStarPositionX: CGFloat?
    @State private var receiveStarPositionY: CGFloat?
    @State var userRole : Bool = false
    
    // 回答者側のViewModel（nil許容）
    var receiverViewModel: ReceiverGameViewModel? = nil
    
    @Binding var userStar: UserStar?
    @State private var anotherUserStar: UserStar? = nil
    @Binding var stars: [Star]
    // isLockedをBindingで受け取る。デフォルトはfalse
    @Binding var isLocked: Bool
    
    // デバイスの視野角（仮）
    let horizontalFOV: Double = 60.0 // 水平視野角を60度と仮定
    let verticalFOV: Double = 45.0
    
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                
                
                
                ZStack(alignment: .topTrailing){
                    
                    
                    
                    
//                    VStack{
//                        
//                        
//                        
//                        Spacer()
//                        
//                        Image(systemName: "arrowshape.up.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 40, height: 40)
//                            .foregroundStyle(.white)
//                            .padding(10)
//                            .background(Circle().foregroundStyle(.yellow)
//                            )
//                            .padding(20)
//                            .rotationEffect(ArrowAngle)
//                        
//                    }
//                    .zIndex(2)
                    //
                    //                    VStack{
                    //                        Text("\(motionModel.signedVerticalAngle)")
                    //                        Text("\(motionModel.pitch)")
                    //                        Text("\(headingManager.heading)")
                    //                    }
                    //                    .foregroundStyle(.white)
                    //                    .zIndex(1)
                    // ここにカメラのプレビュー画面などを背景として表示すると、よりARらしくなります
                    LinearGradient(
                        colors: [
                            Color(red: 0.05, green: 0.05, blue: 0.1),
                            Color(red: 0.1, green: 0.1, blue: 0.25),
                            Color(red: 0.2, green: 0.4, blue: 0.5)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                        .edgesIgnoringSafeArea(.all)
                        .gesture(
                            (gameCenterManager.localPlayerRole == .publisher && !isLocked) ?
                            DragGesture(minimumDistance: 0)
                                .onEnded { value in
                                    let tapLocation = value.location
                                    let deviceAzimuth = headingManager.heading
                                    let deviceAltitude = motionModel.signedVerticalAngle
                                    
                                    let azimuthDifference = (Double(tapLocation.x) - geometry.size.width / 2) / (geometry.size.width / 2) * (horizontalFOV / 2)
                                    let altitudeDifference = -(Double(tapLocation.y) - geometry.size.height / 2) / (geometry.size.height / 2) * (verticalFOV / 2)
                                    
                                    let tappedAzimuth = deviceAzimuth + azimuthDifference
                                    let tappedAltitude = deviceAltitude + altitudeDifference
                                    
                                    let newUserStar = UserStar(name: "ずぼし", azimuth: tappedAzimuth, altitude: tappedAltitude)
                                    userStar = newUserStar
                                } : nil
                        )

                    
                    ForEach(Array(stars.enumerated()), id: \.offset){index ,star in
                        if let starPosition = locationViewModel.starPosition(ra: star.ra, dec: star.dec) {
                            
                            
                            
                            // 1. 天体とデバイスの向きの差を計算
                            //    正規化して-180° ~ +180°の範囲に収める
                            let azimuthDifference = normalizeAngle(starPosition.azimuthNorth - headingManager.heading)
                            let altitudeDifference = starPosition.altitude - motionModel.signedVerticalAngle
                            
                            //                            let azimuthDifference = normalizeAngle(starPosition.azimuthNorth - motionModel.forwardAzimuth)
                            //                            let altitudeDifference = starPosition.altitude - motionModel.altitude
                            // 2. 差分を画面上のオフセットに変換
                            
                            //    水平方向：視野角と画面幅を使って計算
                            let screenX = geometry.size.width / 2 + CGFloat(azimuthDifference / (horizontalFOV / 2)) * (geometry.size.width / 2)
                            
                            //    垂直方向：Y軸は上がマイナスなので符号を反転
                            let screenY = geometry.size.height / 2 - CGFloat(altitudeDifference / (verticalFOV / 2)) * (geometry.size.height / 2)
                            
                            // 画面内に収まっているかチェック
                            if abs(azimuthDifference) < horizontalFOV / 2 && abs(altitudeDifference) < verticalFOV / 2 {
                                // 3. 計算した位置に天体を描画
                                Button{
                                    if gameCenterManager.localPlayerRole == .receiver {
                                        if let starPosition = locationViewModel.starPosition(ra: star.ra, dec: star.dec) {
                                            receiverViewModel?.guessedStar = UserStar(name: star.name, azimuth: starPosition.azimuthNorth, altitude: starPosition.altitude)
                                            print("推測した星: \(star.name)")
                                        }
                                    } else {
                                        stars[index].collectStar = true
                                        gameCenterManager.sendIndex(index)
                                    }
                                }label:{
                                    StarView(star: star)
                                }
                                .position(x:screenX, y:screenY)
                                .overlay(
                                    // 回答者側で、この星が推測の星として選択されているなら緑の円を表示
                                    (receiverViewModel?.guessedStar?.name == star.name) ?
                                        Circle().stroke(Color.green, lineWidth: 3).frame(width: 40, height: 40).position(x: screenX, y: screenY)
                                        : nil
                                )
                                
                            }
                        } else {
                            Text("位置情報を取得中...")
                                .foregroundColor(.black)
                        }
                        
                        
                    }
                    
                    
                    
                    if let userStar = userStar {
                        // starPositionの代わりにuserStarの値を直接使う
                        let azimuthDifference = normalizeAngle(userStar.azimuth - headingManager.heading)
                        let altitudeDifference = userStar.altitude - motionModel.signedVerticalAngle
                        
                        // 画面内に収まっているかチェック
                        if abs(azimuthDifference) < horizontalFOV / 2 && abs(altitudeDifference) < verticalFOV / 2 {
                            
                            // screenX, screenYの計算式は本物の星と全く同じ
                            let screenX = geometry.size.width / 2 + CGFloat(azimuthDifference / (horizontalFOV / 2)) * (geometry.size.width / 2)
                            let screenY = geometry.size.height / 2 - CGFloat(altitudeDifference / (verticalFOV / 2)) * (geometry.size.height / 2)
                            
                            // 仮のStarオブジェクトでStarViewを表示
                            StarView(star: Star(name: userStar.name, ra: "", dec: "", vmag: 1.5, collectStar: false))
                                .position(x: screenX, y: screenY)
                        }
                    }
                    if let anotherUserStar = anotherUserStar {
                        let azimuthDifference = normalizeAngle(anotherUserStar.azimuth - headingManager.heading)
                        let altitudeDifference = anotherUserStar.altitude - motionModel.signedVerticalAngle
                        
                        // 画面内に収まっているかチェック
                        if abs(azimuthDifference) < horizontalFOV / 2 && abs(altitudeDifference) < verticalFOV / 2 {
                            let screenX = geometry.size.width / 2 + CGFloat(azimuthDifference / (horizontalFOV / 2)) * (geometry.size.width / 2)
                            let screenY = geometry.size.height / 2 - CGFloat(altitudeDifference / (verticalFOV / 2)) * (geometry.size.height / 2)
                            
                            // 相手の星を表示（色や見た目を変えて区別）
                            Button{
                                if gameCenterManager.localPlayerRole == .receiver {
                                    receiverViewModel?.guessedStar = anotherUserStar
                                    print("推測した星: 相手の星")
                                }
                            }label: {
                                StarView(star: Star(name: "相手の星", ra: "", dec: "", vmag: 2.0, collectStar: false))
                            }
                                .position(x: screenX, y: screenY)
                                .overlay(
                                    Group {
                                        if receiverViewModel?.guessedStar?.name == "相手の星" {
                                            Circle().stroke(Color.green, lineWidth: 3).frame(width: 40, height: 40)
                                        } else {
                                            Circle().stroke(Color.red, lineWidth: 2).frame(width: 30, height: 30)
                                        }
                                    }.position(x: screenX, y: screenY)
                                )
                        }
                    }
                    
                   
                }
                .onReceive(gameCenterManager.$lastReceivedAction) { receivedAction in
                    if let action = receivedAction, action.action == .selectIndex {
                        self.opponentSelectedIndex = action.selectedIndex
                    }
                    
                    if let action = receivedAction, action.action == .selectDoubtStar {
                        // 天球座標を直接受け取る
                        if let azimuth = action.doubtStarAzimuth,
                           let altitude = action.doubtStarAltitude {
                            // 直接UserStarを作成
                            self.anotherUserStar = UserStar(
                                name: "相手の星",
                                azimuth: azimuth,
                                altitude: altitude
                            )
                            print("相手の星を受信: 方位角 \(azimuth), 高度 \(altitude)")
                        }
                    }
                }
                    // 位置情報が取得できたら星を表示
                
                
                
                
            }
            
            .onAppear {
                // センサーの更新を開始
                motionModel.start()
            }
            .onDisappear {
                // センサーを停止
                motionModel.stop()
            }
            
        }
        
    }
    
    // 角度を-180°から+180°の間に正規化する関数
    private func normalizeAngle(_ angle: Double) -> Double {
        var result = angle.truncatingRemainder(dividingBy: 360)
        if result < -180 {
            result += 360
        } else if result > 180 {
            result -= 360
        }
        return result
    }
}



#Preview {
    // プレビュー用のコンテナView
   ContentView()
}

import Foundation
import CoreMotion
import Combine

class CoreMotionModel: ObservableObject {
    let motionManager: CMMotionManager!
    
    // attitudeの値を格納するプロパティ
    
    @Published var pitch: Double = 0.0
    
//    @Published var verticalAngle: Double = 0.0
    @Published var signedVerticalAngle: Double = 0.0
    @Published var test:Double = 0.0
    init() {
        motionManager = CMMotionManager()
        if motionManager.isDeviceMotionAvailable {
                motionManager.showsDeviceMovementDisplay = true // キャリブレーションUIを有効化
            }
    }

    func start() {
            if motionManager.isDeviceMotionAvailable {
                motionManager.deviceMotionUpdateInterval = 0.005
                motionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: .main) { data, error in
                    guard let data = data else { return }
                    
                    // --- 従来の計算 ---
                    self.pitch = data.attitude.pitch
                    
                    // 重力ベクトルを使った角度の計算
                    let gravity = data.gravity
                    let angle = atan2(gravity.y, gravity.z) // 戻り値はラジアン
                    let angleDeg = angle * 180 / .pi
//                    self.signedVerticalAngle = angleDeg + 90 // ラジアンを度に変換
                    
                    // --- ★★★ ここに移動 ★★★ ---
                    // クォータニオンの値を取得
                    let attitude = data.attitude // 更新されたデータからattitudeを取得
                    let qw = attitude.quaternion.w
                    let qx = attitude.quaternion.x
                    let qy = attitude.quaternion.y
                    let qz = attitude.quaternion.z

                    // クォータニオンからピッチ角を計算 (ラジアン)
                    let qpitch = atan2((2 * (qw * qx + qy * qz)), 1 - 2 * (qx * qx + qy * qy))
                    
                    // 計算結果をプロパティに反映
                    // self.test = qpitch // ラジアンのまま格納する場合
                    self.signedVerticalAngle = (qpitch * 180 / .pi)-90 // 度に変換して格納する場合
                }
            }
        }
    func reset() {
        self.stop()
        // 0.1秒後に再度開始する
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.start()
        }
    }

    func stop() {
        if motionManager.isDeviceMotionActive {
            motionManager.stopDeviceMotionUpdates()
        }
    }
}


//磁場から取得した方位
class HeadingManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var heading: Double = 0.0

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // 真北基準の方位（度）
        heading = newHeading.trueHeading
    }
}


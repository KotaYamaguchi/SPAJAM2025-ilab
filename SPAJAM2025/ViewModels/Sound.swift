import AVFoundation

final class AudioManager {
    static let shared = AudioManager()
    private var bgm: AVAudioPlayer?
    private var sfxPlayers: [AVAudioPlayer] = []
    
    func playBGM(_ name: String, ext: String = "mp3", loop: Bool = true) {
        if let url = Bundle.main.url(forResource: name, withExtension: ext),
           let p = try? AVAudioPlayer(contentsOf: url) {
            p.numberOfLoops = loop ? -1 : 0
            p.play()
            bgm = p
        }
    }
    
    func stopBGM() { bgm?.stop() }
    
    func playSFX(_ name: String, ext: String = "mp3") {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext),
              let p = try? AVAudioPlayer(contentsOf: url) else {
            print("❌ not found: \(name).\(ext)")
            return
        }
        p.prepareToPlay()
        p.play()
        sfxPlayers.append(p)                  // 保持
        sfxPlayers.removeAll { !$0.isPlaying } // 終了したら掃除
        print("🔊 \(name)")
    }
}



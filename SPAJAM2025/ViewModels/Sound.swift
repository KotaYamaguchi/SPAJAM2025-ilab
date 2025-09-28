import AVFoundation

final class AudioManager {
    static let shared = AudioManager()
    private var bgm: AVAudioPlayer?
    private var sfxPlayers: [AVAudioPlayer] = []
    private let engine = AVAudioEngine()
    private let sfxNode = AVAudioPlayerNode()
    private let eq = AVAudioUnitEQ(numberOfBands: 0)
    private init() {
        let s = AVAudioSession.sharedInstance()
        try? s.setCategory(.playback, options: [.mixWithOthers])
        try? s.setActive(true)
        
        engine.attach(sfxNode)
        engine.attach(eq)
        engine.connect(sfxNode, to: eq, format: nil)
        engine.connect(eq, to: engine.mainMixerNode, format: nil)
        try? engine.start()
    }
    
    func playBGM(_ name: String, ext: String = "mp3", loop: Bool = true) {
        if let url = Bundle.main.url(forResource: name, withExtension: ext),
           let p = try? AVAudioPlayer(contentsOf: url) {
            p.numberOfLoops = loop ? -1 : 0
            p.play()
            bgm = p
        }
    }
    
    func stopBGM() { bgm?.stop() }
    
    func playSFX(_ name: String, ext: String = "mp3", volume: Float = 1.0) {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext),
              let p = try? AVAudioPlayer(contentsOf: url) else { return }
        p.volume = max(0, min(1, volume)) // 0.0〜1.0
        p.prepareToPlay()
        p.play()
        sfxPlayers.append(p)
        sfxPlayers.removeAll { !$0.isPlaying }
    }
    
    func playSFXLoud(_ name: String, ext: String = "mp3", gainDB: Float = 6) {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext),
              let file = try? AVAudioFile(forReading: url) else { return }
        eq.globalGain = gainDB        // 例: +6dB, やりすぎるとクリップ注意
        if !engine.isRunning { try? engine.start() }
        if !sfxNode.isPlaying { sfxNode.play() }
        sfxNode.scheduleFile(file, at: nil, completionHandler: nil)
    }
}


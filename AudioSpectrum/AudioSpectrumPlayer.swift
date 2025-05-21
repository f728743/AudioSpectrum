//
// AudioSpectrum02
// A demo project for blog: https://juejin.im/post/5c1bbec66fb9a049cb18b64c
// Created by: potato04 on 2019/1/13
//

import AVFoundation

@MainActor
protocol AudioSpectrumPlayerDelegate: AnyObject {
    func player(_ player: AudioSpectrumPlayer, didGenerateSpectrum spectra: [[Float]])
}

@MainActor
class AudioSpectrumPlayer {
    weak var delegate: AudioSpectrumPlayerDelegate?
    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    private let analyzer: RealtimeAnalyzer

    init(bufferSize: Int = 2048) {
        analyzer = RealtimeAnalyzer(fftSize: bufferSize)
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: nil)
        engine.prepare()
        try? engine.start()
        installTap(bufferSize: bufferSize)
    }

    func installTap(bufferSize: Int) {
        engine.mainMixerNode.removeTap(onBus: 0)
        engine.mainMixerNode.installTap(
            onBus: 0,
            bufferSize: AVAudioFrameCount(bufferSize),
            format: nil
        ) { [weak self] buffer, _ in
            guard let self, player.isPlaying else { return }
            buffer.frameLength = AVAudioFrameCount(bufferSize)
            let spectra = analyzer.analyse(with: buffer)
            delegate?.player(self, didGenerateSpectrum: spectra)
        }
    }

    func play(withFileName fileName: String) {
        guard let audioFileURL = Bundle.main.url(forResource: fileName, withExtension: nil),
              let audioFile = try? AVAudioFile(forReading: audioFileURL) else { return }
        player.stop()
        delegate?.player(self, didGenerateSpectrum: [])
        player.scheduleFile(audioFile, at: nil, completionHandler: nil)
        player.play()
    }

    func stop() {
        delegate?.player(self, didGenerateSpectrum: [])
        player.stop()
    }
}

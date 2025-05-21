//
//  PlayerViewModel.swift
//  AudioSpectrum
//
//  Created by Alexey Vorobyov on 21.05.2025.
//

import Foundation
import Observation

@Observable @MainActor
class PlayerViewModel {
    var player: AudioSpectrumPlayer
    var spectra: [[Float]] = []

    var trackPaths: [String] = {
        var paths = Bundle.main.paths(forResourcesOfType: "m4a", inDirectory: nil)
        paths.sort()
        return paths.map { $0.components(separatedBy: "/").last! }
    }()

    var currentPlayingRow: Int?

    init() {
        player = AudioSpectrumPlayer()
        player.delegate = self
    }

    func playStopTapped(index: Int) {
        if currentPlayingRow == index {
            stopTapped(index: index)
        } else {
            playTapped(index: index)
        }
    }
}

private extension PlayerViewModel {
    func playTapped(index: Int) {
        guard trackPaths.indices.contains(index) else { return }
        currentPlayingRow = index
        player.play(withFileName: trackPaths[index])
    }

    func stopTapped(index _: Int) {
        currentPlayingRow = nil
        player.stop()
    }
}

extension PlayerViewModel: AudioSpectrumPlayerDelegate {
    func player(_: AudioSpectrumPlayer, didGenerateSpectrum spectra: [[Float]]) {
        DispatchQueue.main.async {
            self.spectra = spectra
        }
    }
}

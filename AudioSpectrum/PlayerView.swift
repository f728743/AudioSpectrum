//
//  PlayerView.swift
//  AudioSpectrum
//
//  Created by Alexey Vorobyov on 21.05.2025.
//

import SwiftUI

struct PlayerView: View {
    @State var viewModel = PlayerViewModel()

    var body: some View {
        VStack {
            AudioSpectra(spectra: viewModel.spectra)
                .frame(height: 300)
                .background(Color.gray.tertiary)
            ForEach(Array(viewModel.trackPaths.enumerated()), id: \.offset) { index, element in
                MediaView(title: element, isPlaying: viewModel.currentPlayingRow == index)
                    .onTapGesture {
                        viewModel.playStopTapped(index: index)
                    }
            }
        }
        .padding()
    }
}

struct MediaView: View {
    let title: String
    let isPlaying: Bool
    var body: some View {
        HStack {
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .foregroundColor(isPlaying ? .blue : .green)
                .frame(width: 20)
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.gray.tertiary)
        .cornerRadius(8)
    }
}

#Preview {
    PlayerView()
}

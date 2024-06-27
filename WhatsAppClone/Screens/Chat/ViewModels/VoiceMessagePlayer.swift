//
//  VoiceMessagePlayer.swift
//  WhatsAppClone
//
//  Created by Jeremy Koo on 6/26/24.
//

import Foundation
import AVFoundation

final class VoiceMessagePlayer: ObservableObject {
    
    private var player: AVPlayer?
    private(set) var currentURL: URL?
    
    @Published private(set) var playerItem: AVPlayerItem?
    @Published private(set) var playbackState = PlaybackState.stopped
    @Published private(set) var currentTime = CMTime.zero
    private var currentTimeObserver: Any?
    
    deinit {
        tearDown()
    }
    
    func playAudio(from url: URL) {
        if let currentURL = currentURL, currentURL == url {
            // resumes a previouse message that we were already playing
            resumePlaying()
        } else {
            // plays voice message
            currentURL = url
            let playerItem = AVPlayerItem(url: url)
            self.playerItem = playerItem
            player = AVPlayer(playerItem: playerItem)
            player?.play()
            playbackState = .playing
            observeCurrentPlayerTime()
            observeEndOfPlayback()
        }
    }
    
    func pauseAudio() {
        player?.pause()
        playbackState = .paused
    }
    
    func seek(to timeInterval: TimeInterval) {
        guard let player = player else { return }
        let targetTime = CMTime(seconds: timeInterval, preferredTimescale: 1)
        player.seek(to: targetTime)
    }
    
    // MARK: - Private Methods
    private func resumePlaying() {
        if playbackState == .paused || playbackState == .stopped {
            player?.play()
            playbackState = .playing
        }
    }
    
    private func observeCurrentPlayerTime() {
        currentTimeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: DispatchQueue.main) { [weak self] time in
            self?.currentTime = time
            print("observeCurrentPlayerTime: \(time)")
        }
    }
    
    private func observeEndOfPlayback() {
        NotificationCenter.default.addObserver(forName: AVPlayerItem.didPlayToEndTimeNotification, object: player?.currentItem, queue: .main) { [weak self] _ in
            self?.stopAudioPlayer()
            print("observeEndOfPlayback")
        }
    }
    
    private func stopAudioPlayer() {
        player?.pause()
        player?.seek(to: .zero)
        playbackState = .stopped
        currentTime = .zero
    }
    
    private func removeObservers() {
        guard let currentTimeObserver else { return }
        player?.removeTimeObserver(currentTimeObserver)
        self.currentTimeObserver = nil
        print("removeObservers fired")
    }
    
    private func tearDown() {
        removeObservers()
        player = nil
        playerItem = nil
        currentURL = nil
    }
}

extension VoiceMessagePlayer {
    enum PlaybackState {
        case stopped, playing, paused
        var icon: String {
            return self == .playing ? "pause.fill" : "play.fill"
        }
    }
}

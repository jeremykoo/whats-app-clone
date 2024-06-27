//
//  BubbleAudioView.swift
//  WhatsAppClone
//
//  Created by Jeremy Koo on 5/7/24.
//

import SwiftUI
import AVKit

struct BubbleAudioView: View {
    @EnvironmentObject private var voiceMessagePlayer: VoiceMessagePlayer
    @State private var playbackState: VoiceMessagePlayer.PlaybackState = .stopped
    
    @State private var sliderValue: Double = 0
    @State private var sliderRange: ClosedRange<Double> = 0...20
    @State private var playbackTime = "00:00"
    @State private var isDraggingSlider = false
    
    let item: MessageItem
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 5) {
            
            if item.showGroupPartnerInfo {
                CircularProfileImageView(item.sender?.profileImageUrl, size: .mini)
                    .offset(y: 5)
            }
            
            if item.direction == .sent {
                timeStampTextView()
            }
            
            HStack {
                playButton()
                Slider(value: $sliderValue, in: sliderRange) { editing in
                    isDraggingSlider = editing
                    if !editing {
                        voiceMessagePlayer.seek(to: sliderValue)
                    }
                }
                .tint(.gray)
                
                if playbackState == .stopped {
                    Text(item.audioDurationInString)
                        .foregroundStyle(.gray)
                } else {
                    Text(playbackTime)
                        .foregroundStyle(.gray)
                }
            }
            .padding(10)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(5)
            .background(item.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .applyTail(item.direction)
            
            if item.direction == .received {
                timeStampTextView()
            }
        }
        .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5, x: 0, y: 20)
        .frame(maxWidth: .infinity, alignment: item.alignment)
        .padding(.leading, item.leadingPadding)
        .padding(.trailing, item.trailingPadding)
        .onReceive(voiceMessagePlayer.$playbackState) { state in
            observePlaybackState(state)
        }
        .onReceive(voiceMessagePlayer.$currentTime) { currentTime in
            guard voiceMessagePlayer.currentURL?.absoluteString == item.audioURL else { return }
            listen(to: currentTime)
        }
        .onReceive(voiceMessagePlayer.$playerItem) { playerItem in
            guard voiceMessagePlayer.currentURL?.absoluteString == item.audioURL else { return }
            guard let audioDuration = item.audioDuration else { return }
            
            sliderRange = 0...audioDuration
        }
    }
    
    private func playButton() -> some View {
        Button {
            handlePlayVoiceMessage()
        } label: {
            Image(systemName: playbackState.icon)
                .padding(10)
                .background(item.direction == .received ? .green : .white)
                .clipShape(Circle())
                .foregroundStyle(item.direction == .received ? .white : .black)
        }
    }
    
    private func timeStampTextView() -> some View {
        Text("3:05 PM")
            .font(.footnote)
            .foregroundStyle(.gray)
    }
}

// MARK: - VoiceMessagePlayer Playback States
extension BubbleAudioView {
    private func handlePlayVoiceMessage() {
        if playbackState == .stopped || playbackState == .paused {
            guard let audioURLString = item.audioURL, let voiceMessageUrl = URL(string: audioURLString) else { return }
            voiceMessagePlayer.playAudio(from: voiceMessageUrl)
        } else {
            voiceMessagePlayer.pauseAudio()
        }
    }
    
    private func observePlaybackState(_ state: VoiceMessagePlayer.PlaybackState) {
        if state == .stopped {
            playbackState = .stopped
            sliderValue = 0
        } else {
            guard voiceMessagePlayer.currentURL?.absoluteString == item.audioURL else { return }
            playbackState = state
        }
    }
    
    private func listen(to currentTime: CMTime) {
        guard !isDraggingSlider else { return }
        playbackTime = currentTime.seconds.formatElapsedTime
        sliderValue = currentTime.seconds
    }
}

#Preview {
    ScrollView {
        BubbleAudioView(item: .sentPlaceholder)
        BubbleAudioView(item: .receivedPlaceholder)
            
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal)
    .background(Color.gray.opacity(0.4))
    .onAppear {
        let thumbImage = UIImage(systemName: "circle.fill")
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
    }
}

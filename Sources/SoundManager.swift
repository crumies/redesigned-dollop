import Foundation
import AVFoundation
import AudioToolbox
import UIKit

@MainActor
final class SoundManager {
    static let shared = SoundManager()
    private var player: AVAudioPlayer?

    func playStartupSound(enabled: Bool) {
        guard enabled else { return }
        play("startup")
    }

    func playScanningSound(enabled: Bool) {
        guard enabled else { return }
        play("scanning")
    }

    func playConnectSound(enabled: Bool) {
        guard enabled else { return }
        play("connected")
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    private func play(_ name: String) {
        player?.stop()
        player = nil

        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("Missing sound file: \(name).mp3")
            return
        }

        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try session.setActive(true, options: [])

            let newPlayer = try AVAudioPlayer(contentsOf: url)
            newPlayer.volume = 1.0
            newPlayer.prepareToPlay()
            newPlayer.play()
            player = newPlayer
        } catch {
            print("Sound playback failed: \(error)")
        }
    }
}

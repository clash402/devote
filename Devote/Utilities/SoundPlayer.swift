//
//  SoundPlayer.swift
//  Devote
//
//  Created by Josh Courtney on 7/6/21.
//

import AVFoundation

var audioPlayer: AVAudioPlayer?

func play(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Could not play the sound file")
        }
    } else {
        print("Could not find the sound file")
    }
}

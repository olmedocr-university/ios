//
//  MusicPlayer.swift
//  MyPlayer
//
//  Created by Raul Olmedo on 3/1/21.
//

import Foundation
import UIKit
import AVFoundation
import OSLog

protocol MusicPlayerDelegate: class {
    func getNextTrack(currentTrack: String) -> String
}

class MusicPlayer: NSObject {
    static let shared = MusicPlayer()
    let TAG = OSLog.musicPlayer
    
    weak var delegate: MusicPlayerDelegate?
    weak var playerViewController: PlayerViewController?
    var audioPlayer: AVAudioPlayer?
    var tracksPath: URL?
    var currentTrack: String?
    
    func setupMiniPlayer(tabBarController: UITabBarController) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "playerViewController") as? PlayerViewController else {
            os_log("setupMiniPlayer: unable to obtain the player view from the storyboard", log: TAG, type: .error)
            return
        }
        
        playerViewController = viewController
        
//        let playButton = UIButton()
//        playButton.action = #selector(didTapPlayPause)
//        playButton.image = UIImage(systemName: "play.pause")
//
//        let skipButton = UIButton()
//        skipButton.action = #selector(didTapSkip)
//        skipButton.image = UIImage(systemName: "skip.fill")
        
        viewController.popupItem.barButtonItems
        tabBarController.presentPopupBar(withContentViewController: viewController, animated: true, completion: {
            os_log("setupMiniPlayer: correctly setup mini player", log: self.TAG, type: .debug)
        })
    }
    
    @objc func didTapPlayPause(sender: UIBarButtonItem!) {
        guard let audioPlayer = audioPlayer else {
            os_log("didTapPlayPause: unknown player state", log: TAG, type: .error)
            return
        }
        
        if audioPlayer.isPlaying {
            sender.image = UIImage(systemName: "play.fill")
            audioPlayer.pause()
            
            os_log("didTapPlayPause: playback stopping", log: TAG, type: .debug)
        } else {
            sender.image = UIImage(systemName: "pause.fill")
            audioPlayer.play()
            
            os_log("didTapPlayPause: playback resumed", log: TAG, type: .debug)
        }

    }
    
    @objc func didTapSkip(sender: UIBarButtonItem!) {
        playNextTrack()
    }

    func playTrack(track: String) {
        guard let soundPath = tracksPath?.appendingPathComponent(track) else {
            os_log("playTrack: unable to find the sound in the provided path", log: TAG, type: .error)
            
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundPath)
            
            guard let audioPlayer = audioPlayer else {
                os_log("playTrack: audioPlayer could not be used, is nil", log: TAG, type: .error)
                return
            }
            
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
            currentTrack = track
            
            playerViewController?.popupItem.title = currentTrack
            playerViewController?.popupItem.image = UIImage(named: "Placeholder")

            
            os_log("playTrack: currently playing track is now %{public}@", log: TAG, type: .debug, currentTrack ?? "nil")

        } catch {
            os_log("playTrack: unable to reproduce the sound using AVAudioPlayer", log: TAG, type: .error)
    
        }
    }
    
    func playNextTrack() {
        guard let currentTrack = currentTrack else {
            os_log("didTapSkip: unable to get current track", log: TAG, type: .error)
            return
        }
        
        guard let nextTrack = delegate?.getNextTrack(currentTrack: currentTrack) else {
            os_log("didTapSkip: unable to get next track", log: TAG, type: .error)
            return
        }
        
        playTrack(track: nextTrack)
    }
}

extension MusicPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playNextTrack()
    }
}

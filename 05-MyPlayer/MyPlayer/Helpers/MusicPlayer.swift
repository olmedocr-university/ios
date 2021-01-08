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
import Alamofire
import Kingfisher

protocol MusicPlayerDelegate: class {
    func getNextTrack(currentTrack: String) -> String
    func getPreviousTrack(currentTrack: String) -> String
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
        
        let pauseButton = UIBarButtonItem(image: UIImage(systemName: "pause.fill"), style: .plain, target: self, action: #selector(didTapPlayPause))
        let skipButton = UIBarButtonItem(image: UIImage(systemName: "forward.fill"), style: .plain, target: self, action: #selector(didTapSkip))
        
        pauseButton.width = 60
        skipButton.width = 60
        
        playerViewController?.popupItem.barButtonItems = [pauseButton, skipButton]
        playerViewController?.popupBar.progressViewStyle = .top
        
        tabBarController.presentPopupBar(withContentViewController: viewController, animated: true, completion: {
            os_log("setupMiniPlayer: correctly setup mini player", log: self.TAG, type: .debug)
        })
    }
    
    @objc func didTapPlayPause(sender: UIBarButtonItem!) {
        playPauseCurrentTrack()
        updatePopupBar()
        
    }
    
    @objc func didTapSkip(sender: UIBarButtonItem!) {
        playNextTrack()
        updatePopupBar()
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
            
            audioPlayer.delegate = self
            
            currentTrack = track
            
            playerViewController?.popupItem.title = currentTrack
            playerViewController?.popupItem.image = UIImage(named: "Placeholder")
            playerViewController?.popupItem.progress = 0.0
            
            fetchArtwork(trackName: (currentTrack?.replacingOccurrences(of: ".m4a", with: ""))!) { (url) in
                self.downloadImage(urlString: url)
            }
            
            playerViewController?.trackTitle.text = currentTrack
            playerViewController?.trackImage.image = UIImage(named: "Placeholder")
            playerViewController?.durationSlider.maximumValue = Float(audioPlayer.duration)
            playerViewController?.durationSlider.minimumValue = 0.0
            
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
            updatePopupBar()
            
            os_log("playTrack: currently playing track is now %{public}@", log: TAG, type: .debug, currentTrack ?? "nil")
            
        } catch {
            os_log("playTrack: unable to reproduce the sound using AVAudioPlayer", log: TAG, type: .error)
            
            guard let playerViewController = playerViewController else {
                os_log("playTrack: unable to present alert to user", log: TAG, type: .error)
                return
            }
            
            let alert = playerViewController.setAlert(title: "Error", message: "Unable to play the track, check that is correctly added in iTunes", actionTitle: "OK")
            playerViewController.present(alert, animated: true) {
                return
            }
            
        }
    }
    
    func playPauseCurrentTrack() {
        guard let audioPlayer = audioPlayer else {
            os_log("didTapPlayPause: unknown player state", log: TAG, type: .error)
            return
        }
        
        if audioPlayer.isPlaying {
            audioPlayer.pause()
            
            os_log("didTapPlayPause: playback stopping", log: TAG, type: .debug)
        } else {
            audioPlayer.play()
            
            os_log("didTapPlayPause: playback resumed", log: TAG, type: .debug)
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
    
    func playPreviousTrack() {
        guard let currentTrack = currentTrack else {
            os_log("playPreviousTrack: unable to get current track", log: TAG, type: .error)
            return
        }
        
        guard let previousTrack = delegate?.getPreviousTrack(currentTrack: currentTrack) else {
            os_log("playPreviousTrack: unable to get next track", log: TAG, type: .error)
            return
        }
        
        playTrack(track: previousTrack)
    }
    
    func updatePopupBar() {
        guard let isPlaying = audioPlayer?.isPlaying else {
            return
        }
        
        if isPlaying {
            playerViewController?.popupItem.barButtonItems?.first?.image = UIImage(systemName: "pause.fill")
        } else {
            playerViewController?.popupItem.barButtonItems?.first?.image = UIImage(systemName: "play.fill")
        }
    }
    
    @objc func updateTime() {
        playerViewController?.popupItem.progress = Float(audioPlayer!.currentTime) / Float(audioPlayer!.duration)
        playerViewController?.durationSlider.value = Float(audioPlayer!.currentTime)
    }
    
    func downloadImage(urlString : String){
        guard let url = URL.init(string: urlString) else {
            return
        }
        let resource = ImageResource(downloadURL: url)

        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                self.playerViewController?.popupItem.image = value.image
                self.playerViewController?.trackImage.image = value.image
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

extension MusicPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playNextTrack()
    }
}

extension MusicPlayer {
    func fetchArtwork(trackName: String, onCompletion: @escaping (String) -> Void) {
        fetchTrack(trackName: trackName) { (result) in
            
            let url = "https://api.deezer.com/search"
            let parameters: [String : String] = [
                "q" : result.track.trackName
            ]
          
            AF.request(url, parameters: parameters)
                .responseDecodable(of: ArtworkResponse.self) { (response) in
                    guard let artwork = response.value?.data.first?.album.coverUrl else { return }
                    onCompletion(artwork)
                }
        }
    }
    
    func fetchTrack(trackName: String, onCompletion: @escaping (Track) -> Void) {
        let url = "https://api.musixmatch.com/ws/1.1/track.search"
        let parameters: [String : String] = [
            "apikey" : "182244511a89cf75e05508d9b71c1d50",
            "q_track_artist" : trackName
        ]
        
        AF.request(url, parameters: parameters)
            .responseDecodable(of: TrackResponse.self) { (response) in
                guard let track = response.value?.message.body.trackList.first else { return }
                onCompletion(track)
            }
    }
    
    func fetchLyrics(onCompletion: @escaping (String) -> Void) {
        guard let currentTrack = currentTrack else {
            return
        }
        
        fetchTrack(trackName: currentTrack.replacingOccurrences(of: ".m4a", with: "")) { (result) in
            
            let url = "https://api.musixmatch.com/ws/1.1/track.lyrics.get"
            let parameters: [String : Any] = [
                "apikey" : "182244511a89cf75e05508d9b71c1d50",
                "track_id" : result.track.trackId
            ]
          
            AF.request(url, parameters: parameters)
                .responseDecodable(of: LyricsResponse.self) { (response) in
                    guard let lyrics = response.value?.message.body.lyrics.lyricsBody else { return }
                    onCompletion(lyrics)
                }
        }
    }
}

//
//  MiniPlayerViewController.swift
//  MyPlayer
//
//  Created by Raul Olmedo on 28/12/20.
//

import UIKit
import OSLog
import AVFoundation

protocol MiniPlayerDelegate: class {
    func getNextTrack(currentTrack: String) -> String
}

class MiniPlayerViewController: UIViewController {
    
    // MARK: Properties
    let TAG = OSLog.miniPlayerViewController
    weak var delegate: MiniPlayerDelegate?
    var audioPlayer = AVAudioPlayer()
    var tracksPath: URL?
    var currentTrack: String?
    
    // MARK: - IBOutlets
    @IBOutlet weak var labelTrack: UILabel!
    @IBOutlet weak var buttonPlayPause: UIButton!
    @IBOutlet weak var imageTrack: UIImageView!
    
    // MARK: IBActions
    @IBAction func didTapPlayPause(_ sender: UIButton) {
        if audioPlayer.isPlaying {
            buttonPlayPause.setImage(UIImage(systemName: "play.fill"), for: .normal)
            audioPlayer.pause()
            
            os_log("didTapPlayPause: playback stopping", log: TAG, type: .debug)
        } else {
            buttonPlayPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            audioPlayer.play()
            
            os_log("didTapPlayPause: playback resumed", log: TAG, type: .debug)
        }

    }
    
    @IBAction func didTapSkip(_ sender: UIButton) {
        playNextTrack()
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        imageTrack.layer.cornerRadius = CGFloat(5)
        imageTrack.clipsToBounds = true
        
        buttonPlayPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    // MARK: - Internal
    func playTrack(track: String) {
        guard let soundPath = tracksPath?.appendingPathComponent(track) else {
            os_log("playTrack: unable to find the sound in the provided path", log: TAG, type: .error)
            
            let alert = setAlert(title: "Error", message: "Unable to find the track in the files, add it using iTunes", actionTitle: "OK")
            self.present(alert, animated: true) {
                return
            }
            
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundPath)
            audioPlayer.play()
            currentTrack = track
            os_log("playTrack: currently playing track is now %{public}@", log: TAG, type: .debug, currentTrack ?? "nil")

        } catch {
            os_log("playTrack: unable to reproduce the sound using AVAudioPlayer", log: TAG, type: .error)
            
            let alert = setAlert(title: "Error", message: "Internal error while playing the track", actionTitle: "OK")
            self.present(alert, animated: true) {
                return
            }
        }
    }
    
    func playNextTrack() {
        guard let currentTrack = currentTrack else {
            os_log("didTapSkip: unable to get current track", log: TAG, type: .error)
            return
        }
        
        guard let nextTrack = delegate?.getNextTrack(currentTrack: currentTrack) else {
            os_log("didTapSkip: unable to get next track", log: TAG, type: .error)
            
            let alert = setAlert(title: "Error", message: "Unable to find the track in the files, add it using iTunes", actionTitle: "OK")
            self.present(alert, animated: true) {
                return
            }
            
            return
        }
        
        playTrack(track: nextTrack)
    }
}

extension MiniPlayerViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playNextTrack()
    }
}

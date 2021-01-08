//
//  PlayerViewController.swift
//  MyPlayer
//
//  Created by Raul Olmedo on 3/1/21.
//

import UIKit

class PlayerViewController: UIViewController {
    
    // MARK: Properties
    
    // MARK: IBOutlets
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackSubtitle: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var durationSlider: UISlider!
    
    // MARK: IBActions
    @IBAction func didTapPreviousButton(_ sender: UIButton) {
        MusicPlayer.shared.playPreviousTrack()
        updatePlayPauseButton()
    }
    
    @IBAction func didTapPlayPauseButton(_ sender: UIButton) {
        MusicPlayer.shared.playPauseCurrentTrack()
        updatePlayPauseButton()
    }
    
    @IBAction func didTapNextButton(_ sender: UIButton) {
        MusicPlayer.shared.playNextTrack()
        updatePlayPauseButton()
    }
    
    @IBAction func didTapOnLyricsButton(_ sender: Any) {
        MusicPlayer.shared.fetchLyrics { (lyrics) in
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LyricsViewController") as? LyricsViewController {
                
                viewController.lyrics = lyrics
                self.present(viewController, animated: true)
            }
        }
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        updatePlayPauseButton()
        print(trackImage.debugDescription)

    }
    
    // MARK: Internal
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func updatePlayPauseButton() {
        guard let isPlaying = MusicPlayer.shared.audioPlayer?.isPlaying else {
            return
        }
        
        if isPlaying {
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    

}

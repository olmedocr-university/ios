//
//  MainTableViewController.swift
//  MyPlayer
//
//  Created by Raul Olmedo on 27/12/20.
//

import UIKit
import os
import LNPopupController

class MainTableViewController: UITableViewController {
    
    // MARK: Properties
    let TAG = OSLog.mainTableViewController
    let tracksPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] // Document directory
    var trackList: [String]?
    var musicPlayer: MusicPlayer?
    var isPlaylist: Bool = false
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = true
        
        if !isPlaylist {
            trackList = getStoredTracks()
        }
                
        MusicPlayer.shared.tracksPath = tracksPath
        MusicPlayer.shared.delegate = self
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.allowsSelectionDuringEditing = false
    }

    // MARK: - TableView Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = trackList?.count ?? 0
        return numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if isPlaylist {
            cell = tableView.dequeueReusableCell(withIdentifier: "playlistTrackCell", for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath)
        }

        cell.textLabel?.text = trackList?[indexPath.row]

        return cell
    }
    
    // MARK: TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let selectedTrack = trackList?[indexPath.row] else {
            os_log("tableView::didSelectRowAt unable to get selected track from the trackList", log: TAG, type: .error)
            return
        }
        
        if let _ = MusicPlayer.shared.audioPlayer {
            // Player already setup
        } else {
            MusicPlayer.shared.setupMiniPlayer(tabBarController: tabBarController!)
        }
        
        MusicPlayer.shared.playTrack(track: selectedTrack)
        MusicPlayer.shared.updatePopupBar()
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            trackList?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let rowToMove = trackList?[sourceIndexPath.row] else {
            return
        }
        
        trackList?.remove(at: sourceIndexPath.row)
        trackList?.insert(rowToMove, at: destinationIndexPath.row)
    }
    
    // MARK: - Internal
    func getStoredTracks() -> [String] {
        let fileManager = FileManager.default
        let files = try! fileManager.contentsOfDirectory(atPath: tracksPath.path)
        
        os_log("getStoredTracks: Gathered %{public}d tracks from Documents", log: TAG, type: .debug, files.count)
        
        return files
    }
}

extension MainTableViewController: MusicPlayerDelegate {
    func getNextTrack(currentTrack: String) -> String {
        guard let currentTrackIndex = trackList?.firstIndex(of: currentTrack) else {
            os_log("getNextTrack: unable to get next track index", log: TAG, type: .error)
            return ""
        }
        
        guard let trackListEndIndex = trackList?.endIndex else {
            os_log("getNextTrack: unable to get the last index of the track list", log: TAG, type: .error)
            return ""
        }
        
        if currentTrackIndex + 1 >= trackListEndIndex {
            guard let nextTrack = trackList?[0] else {
                os_log("getNextTrack: unable to get next track after finishing list", log: TAG, type: .error)
                return ""
            }
            
            return nextTrack
        } else {
            guard let nextTrack = trackList?[currentTrackIndex + 1] else {
                os_log("getNextTrack: unable to get next track", log: TAG, type: .error)
                return ""
            }
            
            return nextTrack
        }
    }
    
    func getPreviousTrack(currentTrack: String) -> String {
        guard let currentTrackIndex = trackList?.firstIndex(of: currentTrack) else {
            os_log("getPreviousTrack: unable to get next track index", log: TAG, type: .error)
            return ""
        }
        
        guard let trackListStartIndex = trackList?.startIndex else {
            os_log("getPreviousTrack: unable to get the first index of the track list", log: TAG, type: .error)
            return ""
        }
        
        guard let trackListEndIndex = trackList?.endIndex else {
            os_log("getPreviousTrack: unable to get the last index of the track list", log: TAG, type: .error)
            return ""
        }
        
        if currentTrackIndex - 1 < trackListStartIndex {
            guard let nextTrack = trackList?[trackListEndIndex - 1] else {
                os_log("getPreviousTrack: unable to get previous track after starting list", log: TAG, type: .error)
                return ""
            }
            
            return nextTrack
        } else {
            guard let nextTrack = trackList?[currentTrackIndex - 1] else {
                os_log("getPreviousTrack: unable to get previous track", log: TAG, type: .error)
                return ""
            }
            
            return nextTrack
        }
    }
}

//
//  PlaylistsTableViewController.swift
//  MyPlayer
//
//  Created by Raul Olmedo on 3/1/21.
//

import UIKit

class PlaylistsTableViewController: UITableViewController {

    // MARK: Properties
    let defaults = UserDefaults.standard
    var playlists: [Playlist]?
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        playlists = getStoredPlaylists()
        
        tableView.allowsSelectionDuringEditing = false
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = playlists?.count ?? 0
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath)

        cell.textLabel?.text = playlists?[indexPath.row].name

        return cell
    }
    
    // MARK: TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlaylistDetailViewController") as? MainTableViewController {
            viewController.isPlaylist = true
            viewController.trackList = playlists?[indexPath.row].tracks
            viewController.title = playlists?[indexPath.row].name
            
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            playlists?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let rowToMove = playlists?[sourceIndexPath.row] else {
            return
        }
        
        playlists?.remove(at: sourceIndexPath.row)
        playlists?.insert(rowToMove, at: destinationIndexPath.row)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newPlaylistSegue" {
            guard let destinationNavigationVC = segue.destination as? UINavigationController else {
                return
            }
            
            guard let destinationVC = destinationNavigationVC.children.first as? NewPlaylistViewController else {
                return
            }
            
            destinationVC.delegate = self
        }
    }
    
    // MARK: Internal
    func getStoredPlaylists() -> [Playlist]? {
        let jsonString = readFromUserDefaults(key: "playlists")
        
        guard let jsonData = jsonString?.data(using: .utf8) else {
            return nil
        }
        
        var playlists: [Playlist]
        
        do {
            playlists = try JSONDecoder().decode([Playlist].self, from: jsonData)
            return playlists
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
}

extension PlaylistsTableViewController: NewPlaylistDelegate {
    func didFinishPlaylistSetup(playlistName: String, selectedTracks: [IndexPath]) {
        guard let mainTableViewController = tabBarController?.viewControllers?[0].children[0] as? MainTableViewController else {
            return
        }
        
        var tracks: [String] = []
        
        for index in selectedTracks {
            guard let trackName = mainTableViewController.trackList?[index.row] else {
                return
            }
            
            tracks.append(trackName)
        }
        
        if playlists != nil {
            playlists?.append(Playlist(name: playlistName, tracks: tracks))
        } else {
            playlists = [Playlist(name: playlistName, tracks: tracks)]
        }
        
        tableView.reloadData()
    }
}

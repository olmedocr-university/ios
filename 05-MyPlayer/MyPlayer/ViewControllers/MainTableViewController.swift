//
//  MainTableViewController.swift
//  MyPlayer
//
//  Created by Raul Olmedo on 27/12/20.
//

import UIKit
import os

/*
 TODO:  - Set cool table view cells with images
        - Setup big player to launch on mini player slide
        - Fix button size mini player to make them more clickable
        - Setup MusicXmatch extension
        - Elegir entre carpetas y listas
        - Proponer mini player - big player con animaciones
        - Choose 3:
             Controlar la App desde el Apple Watch
             Crear listas de reproducción ()
             Buscar carátulas y/o información de la pista
             Buscar y mostrar la letra de las canciones
             Gestionar carpetas ()
             Reproducir desde Dropbox (requiere usar API de Dropbox)
             Modo coche (Tabla y reproductor en letras grandes), modo oscuro (iOS 13)
             Cualquier otra mejora que se proponga
 */



class MainTableViewController: UITableViewController {
    
    // MARK: Properties
    let TAG = OSLog.mainTableViewController
    let tracksPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] // Document directory
    var trackList: [String]?
    var miniPlayer: MiniPlayerViewController?
    var isPlaying = false
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = true
        self.navigationItem.title = "MyPlayer"
        
        trackList = getStoredTracks()
    }

    // MARK: - TableView Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = trackList?.count ?? 0
        os_log("tableView::numberOfRowsInSection: Loading %{public}d cells", log: TAG, type: .debug, numberOfRows)

        return numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath)

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
        
        if !isPlaying {
            setMiniPlayer()
            isPlaying = true
        }
        
        miniPlayer?.playTrack(track: selectedTrack)
    }
    
    // MARK: - Internal
    func getStoredTracks() -> [String] {
        let fileManager = FileManager.default
        let files = try! fileManager.contentsOfDirectory(atPath: tracksPath.path)
        
        os_log("getStoredTracks: Gathered %{public}d tracks from Documents", log: TAG, type: .debug, files.count)
        
        return files
    }
    
    func setMiniPlayer(){
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "miniPlayerViewController") as? MiniPlayerViewController else {
            os_log("setMiniPlayer: unable to obtain the mini player view from the storyboard", log: TAG, type: .error)
            
            return
        }

        viewController.tracksPath = tracksPath
        viewController.delegate = self
        
        miniPlayer = viewController

        // Add the child view to the parent and setup constraints programatically
        addChild(viewController)
                
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewController.view)
        
        guard let bottomAnchor = parent?.view.bottomAnchor else {
            os_log("setMiniPlayer: error setting up the miniplayer", log: TAG, type: .error)

            return
        }
        
        NSLayoutConstraint.activate([
            viewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: bottomAnchor),
            viewController.view.heightAnchor.constraint(equalToConstant: 80.0 + view.safeAreaInsets.bottom)
        ])
        
        os_log("setMiniPlayer: miniplayer correctly added to view", log: TAG, type: .debug)

    }
}

extension MainTableViewController: MiniPlayerDelegate {
    func getNextTrack(currentTrack: String) -> String {
        guard let nextTrackIndex = trackList?.firstIndex(of: currentTrack) else {
            os_log("getNextTrack: unable to get next track index", log: TAG, type: .error)
            return ""
        }
        
        guard let trackListEndIndex = trackList?.endIndex else {
            os_log("getNextTrack: unable to get the last index of the track list", log: TAG, type: .error)
            return ""
        }
        
        if nextTrackIndex + 1 >= trackListEndIndex {
            guard let nexTrack = trackList?[0] else {
                os_log("getNextTrack: unable to get next track after finishing list", log: TAG, type: .error)
                return ""
            }
            
            return nexTrack
        } else {
            guard let nexTrack = trackList?[nextTrackIndex + 1] else {
                os_log("getNextTrack: unable to get next track", log: TAG, type: .error)
                return ""
            }
            
            return nexTrack
        }
    }
}
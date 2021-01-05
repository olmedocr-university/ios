//
//  NewPlaylistViewController.swift
//  MyPlayer
//
//  Created by Raul Olmedo on 4/1/21.
//

import UIKit

protocol NewPlaylistDelegate: class {
    func didFinishPlaylistSetup(playlistName: String, selectedTracks: [IndexPath])
}

class NewPlaylistViewController: UIViewController, UITableViewDelegate {
    
    // MARK: Properties
    weak var delegate: NewPlaylistDelegate?
    var tableView: UITableView?

    // MARK: IBOutlets
    @IBOutlet weak var embeddedView: UIView!
    @IBOutlet weak var playlistNameTextField: UITextField!
    
    // MARK: IBActions
    @IBAction func didTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapOnDoneButton(_ sender: Any) {
        guard let selectedTracks = tableView?.indexPathsForSelectedRows else {
            let alert = setAlert(title: "Error", message: "Add at least one song to the playlist", actionTitle: "OK")
            navigationController?.present(alert, animated: true) {
                return
            }
            return
        }
        
        guard let playlistName = playlistNameTextField.text else {
            let alert = setAlert(title: "Error", message: "Add a valid name to the playlist", actionTitle: "OK")
            navigationController?.present(alert, animated: true) {
                return
            }
            return
        }
        
        if playlistName.isEmpty {
            let alert = setAlert(title: "Error", message: "Add a name to the playlist", actionTitle: "OK")
            navigationController?.present(alert, animated: true) {
                return
            }
        } else {
            delegate?.didFinishPlaylistSetup(playlistName: playlistName, selectedTracks: selectedTracks)
            navigationController?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let tableView = embeddedView.subviews.first as? UITableView else {
            return
        }
        
        self.tableView = tableView
        
        tableView.setEditing(true, animated: true)
        tableView.allowsSelectionDuringEditing = false
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.delegate = self
        
    }

}

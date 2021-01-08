//
//  LyricsViewController.swift
//  MyPlayer
//
//  Created by Raul Olmedo on 8/1/21.
//

import UIKit

class LyricsViewController: UIViewController {
    
    var lyrics: String?

    @IBOutlet weak var textViewLyrics: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let lyrics = lyrics else {
            return
        }
        
        textViewLyrics.text = lyrics

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

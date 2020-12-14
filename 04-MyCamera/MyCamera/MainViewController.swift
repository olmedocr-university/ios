//
//  ViewController.swift
//  MyCamera
//
//  Created by Raul Olmedo on 14/12/20.
//

import UIKit

class MainViewController: UIViewController {
    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    var imageName: String?
    var imageURL: URL?
    
    @IBOutlet weak var imageViewPicture: UIImageView!
    
    // MARK: IBActions
    @IBAction func cameraButtonDidPress(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func documentsButtonDidPress(_ sender: Any) {
        let fm = FileManager.default
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        var isPresent = false
        
        do {
            let items = try fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                if item == imageName{
                    isPresent = true
                }
                print("Found \(item)")
            }
        } catch {
            print("Failed to read directory")
        }
        
        
        if isPresent {
            let alert = UIAlertController(title: "File found", message: "The file \(imageName!) is present in the device", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)

            
        } else {
            let alert = UIAlertController(title: "Error!", message: "The file could not be found on the device", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension MainViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        imageViewPicture.image = image

        // Store in documents
        

        imageName = String(Int.random(in: 0 ... 1000000000000)) + ".png"
        imageURL = documents.appendingPathComponent(imageName!)

        if let data = image.pngData() {
            do {
                try data.write(to: imageURL!)
            } catch {
                print("Unable to Write Image Data to Disk")
            }
        }
    }
}

extension MainViewController: UINavigationControllerDelegate {
    
}

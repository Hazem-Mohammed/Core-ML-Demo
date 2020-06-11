//
//  ViewController.swift
//  MLDemo
//
//  Created by Hazem Mohammed on 6/10/20.
//  Copyright © 2020 Hazem Mohammed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var catVsDogImage: UIImageView!
    @IBOutlet weak var checkKindButton: UIButton!
    @IBOutlet weak var kindLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectImageSource(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        let imageSourceActions = UIAlertController(title: "Image Source", message: "Choose image source", preferredStyle: .actionSheet)
        
        imageSourceActions.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
        }))
        
        imageSourceActions.addAction(UIAlertAction(title: "cancel", style: .cancel))
        
        self.present(imageSourceActions, animated: true)
    }
    
    @IBAction func didTapDetectKindButton(_ sender: Any) {
        
        AnimalDetector.startAnimalDetection(catVsDogImage) { (results) in
            
            guard let animal = results.first else { print("NO DETECTION POSSIBLE"); return }
            
            DispatchQueue.main.async {
                
                self.kindLabel.text = "it's a \(animal)"
            }
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { picker.dismiss(animated: true); print("ERROR"); return }
        
        catVsDogImage.image = selectedImage
        catVsDogImage.contentMode = .scaleAspectFill
        
        checkKindButton.isEnabled = true
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}


//
//  ImageViewController.swift
//  better-belly
//
//  Created by Ansar Khan on 2018-09-15.
//  Copyright © 2018 Ansar Khan. All rights reserved.
//

import UIKit
import Firebase;

class ImageViewController: ViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var statsButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    var user:User? = nil;
    var uid = "8ylt6eVzI9hy6wBXgNgkj00JR3Kg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()
        accountButton.setImage(UIImage(named: "person icon.png"), for: .normal)
        
        cameraButton.setImage(UIImage(named: "camera icon.png"), for: .normal)
        statsButton.setImage(UIImage(named: "results icon.png"), for: .normal)
        imagePicker.delegate = self
        
        Auth.auth().signInAnonymously() { (authResult, error) in
            self.user = authResult?.user
            print("Logged In")
        }
    }
    @IBAction func cameraButtonPressed(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {
            print("No image found")
            return
        }
        imageView.image = image;
        
        var imageName = (uid);
        imageName.append(contentsOf: String(Date().timeIntervalSince1970).dropLast(3))
        let storage = Storage.storage()
        
        let storageRef = storage.reference().child(imageName)
        
        let data = UIImageJPEGRepresentation(image,1)
        
        let uploadTask = storageRef.putData(data!, metadata: nil) { metadata, error in
            if (error != nil) {
                print("Unable to upload file")
            } else {
                storageRef.downloadURL(completion: { (url, error) in
                    var ref = Database.database().reference();
                    ref.child("Processed").child(imageName).setValue(["upload_url": url?.absoluteString])
                })
                //Metadata contains file metadata such as size, content-type, and download URL.
                print("Successfully uploaded file")
            }
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

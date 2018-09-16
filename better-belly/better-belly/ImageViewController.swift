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
    
    //-1 = grey outline: image not processed and/or uploaded
    // 0 = red outline: don't eat
    // 1 = green outline: eat
    var imageStatus: Int {
        set{
            switch newValue {
            case 0:
                imageView.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                break;
            case 1:
                imageView.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                
            default:
                imageView.layer.borderColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
            }
            
        }
        get{
            return imageStatus;
        }
    }

    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()
        accountButton.setImage(UIImage(named: "person icon.png"), for: .normal)
        
        cameraButton.setImage(UIImage(named: "camera icon.png"), for: .normal)
        statsButton.setImage(UIImage(named: "results icon.png"), for: .normal)
        imagePicker.delegate = self
        
        imageView.layer.borderWidth = 10;
        
        Auth.auth().signInAnonymously() { (authResult, error) in
            Firebase.user = authResult?.user
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
        
        imageStatus = -1;
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {
            print("No image found")
            return
        }
        imageView.image = image;
        
        var imageName = (Firebase.userRef.key);
        imageName.append(contentsOf: String(Date().timeIntervalSince1970).dropLast(6))
       
        let storage = Storage.storage()
        
        let storageRef = storage.reference().child(imageName)
        
        let data = UIImageJPEGRepresentation(image,1)
        
        let uploadTask = storageRef.putData(data!, metadata: nil) { metadata, error in
            if (error != nil) {
                print("Unable to upload file")
            } else {
                storageRef.downloadURL(completion: { (url, error) in
                    let ref = Firebase.ref;
                    ref.child("Filesuploaded").child(imageName).setValue(["upload_url": url?.absoluteString])
                })
                //Metadata contains file metadata such as size, content-type, and download URL.
                print("Successfully uploaded file")
                self.imageStatus = 0;
            }
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

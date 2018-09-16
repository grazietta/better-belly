//
//  ImageViewController.swift
//  better-belly
//
//  Created by Ansar Khan on 2018-09-15.
//  Copyright © 2018 Ansar Khan. All rights reserved.
//

import UIKit
import Firebase;
import UserNotifications

class ImageViewController: ViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var statsButton: UIButton!
    
    @IBOutlet weak var forkButton: UIButton!
    @IBOutlet weak var notForkButton: UIButton!
    
    let content = UNMutableNotificationContent()
    
    
    var timer: Timer?;
    var dir:CGFloat = 1;
    var y = false
    var needResponse: Bool {
        set{
            y = newValue;
            if(imageStatus <= 1 && imageStatus >= 0){
                forkButton.isHidden = false;
                notForkButton.isHidden = false;
                accountButton.isHidden = true
                cameraButton.isHidden = true
                statsButton.isHidden = true
            }
            else{
                forkButton.isHidden = true;
                notForkButton.isHidden = true;
                accountButton.isHidden = false
                cameraButton.isHidden = false
                statsButton.isHidden = false
            }
        }
        get{
            return y;
        }
    }
    
    //-2 = animation: image processing
    //-1 = grey outline: image not processed and/or uploaded
    // 0 = red outline: don't eat
    // 1 = green outline: eat
    // 2 = done rating
    var x = -1;
    var imageStatus: Int {
        set{
            switch newValue {
            case 0:
                imageView.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                break;
            case 1:
                imageView.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                break;
            case 2:
                break;
                
            default:
                imageView.layer.borderColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
            }
            x = newValue;
        }
        get{
            return x;
        }
    }
    
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountButton.setImage(UIImage(named: "person icon.png"), for: .normal)
        
        cameraButton.setImage(UIImage(named: "camera icon.png"), for: .normal)
        statsButton.setImage(UIImage(named: "results icon.png"), for: .normal)
        imagePicker.delegate = self
        
        
        timer = Timer.scheduledTimer(timeInterval: 1/20, target: self, selector: #selector(ImageViewController.update), userInfo: nil, repeats: true);
        
        imageView.layer.borderWidth = 10;
        imageView.layer.cornerRadius = 20;
        imageView.layer.allowsEdgeAntialiasing = true;
        imageView.layer.masksToBounds = true;
        
    }
    @IBAction func cameraButtonPressed(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        
        
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func forkButtonPressed(_ sender: Any) {
        imageStatus = 2;
        needResponse = false;
        
    }
    @IBAction func notForkButtonPressed(_ sender: Any) {
        imageStatus = 2;
        needResponse = false;
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        dataSent();
        
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {
            print("No image found")
            return
        }
        imageView.image = image;
        
        var imageName = Firebase.userRef.ref.key!
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
                //self.dataArrived(val: 1)//Call this func with results that come from gcp
                
            }
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func dataArrived(val: Int){
        //Metadata contains file metadata such as size, content-type, and download URL.
        self.imageStatus = val;
        self.needResponse = !self.needResponse;
        
    }
    func dataSent(){
        //self.needResponse = !self.needResponse;
        imageStatus = -2;
        Firebase.mealStatusChanged(callback: { (snapshot) in
            
            switch snapshot.value as! String {
            case "good":
                self.imageStatus = 1
            case "bad":
                self.imageStatus = 0
            default:
                self.imageStatus = -1
            }
        })
    }
    
    @objc func update(){
        if(imageStatus != -2){
            imageView.layer.borderWidth = 10;
            return;
        }
        
        if(imageView.layer.borderWidth <= 0 || imageView.layer.borderWidth >= 30){
            dir *= -1;
        }
        imageView.layer.borderWidth += dir
        let c = imageView.layer.borderColor?.copy()?.components!;
        imageView.layer.borderColor = UIColor(red: c![0], green: c![1], blue: c![2], alpha: 1-imageView.layer.borderWidth/30).cgColor
        
    }
}

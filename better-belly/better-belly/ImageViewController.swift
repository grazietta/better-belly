//
//  ImageViewController.swift
//  better-belly
//
//  Created by Ansar Khan on 2018-09-15.
//  Copyright © 2018 Ansar Khan. All rights reserved.
//

import UIKit

class ImageViewController: ViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var accountButton: UIButton!
   
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var statsButton: UIButton!
    
     let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountButton.setImage(UIImage(named: "person icon.png"), for: .normal)
        //accountButton.layer.cornerRadius = 0.5 * accountButton.bounds.size.width;

        cameraButton.setImage(UIImage(named: "camera icon.png"), for: .normal)
        statsButton.setImage(UIImage(named: "results icon.png"), for: .normal)
        imagePicker.delegate = self
        
        

        // Do any additional setup after loading the view.
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
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

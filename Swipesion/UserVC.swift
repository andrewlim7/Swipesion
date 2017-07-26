//
//  UserVC.swift
//  Swipesion
//
//  Created by Andrew Lim on 11/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class UserVC: UIViewController {
    
    @IBOutlet weak var changeProfileImage: UIImageView!
    @IBOutlet weak var updateButton: UIButton!{
        didSet{
            updateButton.addTarget(self, action: #selector(didTappedUpdateButton(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var uploadImageButton: UIButton!{
        didSet{
            uploadImageButton.addTarget(self, action: #selector(didTappedChangeButton(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!{
        didSet{
            cancelButton.target = self
            cancelButton.action = #selector(didTappedCancelButton(_:))
        }
    }

    
    var displayUserImage : UIImage?
    var isImageSelected : Bool = false
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSpinner()
        changeProfileImage.image = displayUserImage
        
        changeProfileImage.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UserVC.imagedTapped(sender:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        changeProfileImage.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func imagedTapped(sender: UITapGestureRecognizer){
        openImagePicker()
    }
    
    func didTappedChangeButton(_ sender: Any){
        openImagePicker()
    }
    
    func openImagePicker(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        let alertController = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                pickerController.sourceType = .camera
                self.present(pickerController, animated: true, completion: nil)
            } else {
                let alertVC = UIAlertController(title: "No Camera",message: "Sorry, this device has no camera",preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok",style:.default,handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true,completion: nil)
                return
            }
        }
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(camera)
        alertController.addAction(photoLibrary)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func updateUserProfileImage(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let storageRef = Storage.storage().reference()
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        let data = UIImageJPEGRepresentation(self.changeProfileImage.image!, 0.8)
        
        storageRef.child("\(uid).jpg").putData(data!, metadata: metadata) { (newMeta, error) in
            if (error != nil) {
                // Uh-oh, an error occurred!
                print(error!)
            } else {
                
                defer{
                    self.dismiss(animated: true, completion: nil) //so the return function will return this
                    self.updateButton.isEnabled = true
                }
                
                if let foundError = error {
                    print(foundError.localizedDescription)
                    self.updateButton.isEnabled = true
                    return
                }
                
                guard let imageURL = newMeta?.downloadURLs?.first?.absoluteString else {
                    self.updateButton.isEnabled = true
                    return
                }
                
                let param : [String : Any] = ["profileImageURL": imageURL]
                
                let ref = Database.database().reference().child("users")
                ref.child(uid).updateChildValues(param)

                let url = URL(string:  imageURL)
                UserDefaults.standard.set(url, forKey: "currentUserProfileImage")
                UserDefaults.standard.synchronize()
            }
            self.myActivityIndicator.stopAnimating()
        }
        
    }
    
    func didTappedCancelButton(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    func didTappedUpdateButton(_ sender: Any){
        myActivityIndicator.startAnimating()
        self.updateButton.isEnabled = false
        self.cancelButton.isEnabled = false
        
        if isImageSelected == true {
            updateUserProfileImage()
        }
    }
    
    func warningAlert(title: String, warningMessage: String){
        let alertController = UIAlertController(title: title, message: warningMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func setupSpinner(){
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = true
        myActivityIndicator.color = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        
        view.addSubview(myActivityIndicator)
    }
}

extension UserVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isImageSelected = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.changeProfileImage.image = selectedImage
        
        self.isImageSelected = true
        
        self.dismiss(animated: true, completion: nil)
        
    }
}

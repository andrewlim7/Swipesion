//
//  RegisterVC.swift
//  Swipesion
//
//  Created by Andrew Lim on 11/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class RegisterVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var userNameLogo: UIImageView! {
        
        didSet {
            
            userNameLogo.tintColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)
        }
    }
    @IBOutlet weak var emailLogo: UIImageView! {
        
        didSet {
            
            emailLogo.tintColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)
        }
    }
    @IBOutlet weak var passwordLogo: UIImageView! {
        
        didSet {
            
            passwordLogo.tintColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)
        }
    }
    @IBOutlet weak var confirmPasswordLogo: UIImageView! {
        
        didSet {
            confirmPasswordLogo.tintColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)
            
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var usernameTextField: UITextField!{
        didSet{
            usernameTextField.attributedPlaceholder = NSAttributedString(string: "Name",
                                                                         attributes: [NSForegroundColorAttributeName: UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)])
            usernameTextField.delegate = self
            let border = CALayer()
            let width = CGFloat(1.0)
            border.borderColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1).cgColor
            border.frame = CGRect(x: 0, y: usernameTextField.frame.size.height - width, width:  usernameTextField.frame.size.width + 18, height: usernameTextField.frame.size.height)
            
//            let logoImage = UIImageView(image: UIImage(named: "user"))
//            logoImage.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            
            border.borderWidth = width
            usernameTextField.layer.addSublayer(border)
            usernameTextField.layer.masksToBounds = true
//            usernameTextField.leftView = logoImage
//            usernameTextField.leftView?.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
//            usernameTextField.leftViewMode = .always
            usernameTextField.textAlignment = .center
            usernameTextField.textColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)
            
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                      attributes: [NSForegroundColorAttributeName: UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)])
            emailTextField.delegate = self
            let border = CALayer()
            let width = CGFloat(1.0)
            border.borderColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1).cgColor
            border.frame = CGRect(x: 0, y: emailTextField.frame.size.height - width, width:  emailTextField.frame.size.width + 18, height: emailTextField.frame.size.height)
            
//            let logoImage = UIImageView(image: UIImage(named: "email"))
//            logoImage.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            
            border.borderWidth = width
            emailTextField.layer.addSublayer(border)
            emailTextField.layer.masksToBounds = true
//            emailTextField.leftView = logoImage
//            emailTextField.leftView?.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
//            emailTextField.leftViewMode = .always
            emailTextField.textAlignment = .center
            emailTextField.textColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)
            
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                      attributes: [NSForegroundColorAttributeName: UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)])
            passwordTextField.isSecureTextEntry = true
            passwordTextField.delegate = self
            
            let border = CALayer()
            let width = CGFloat(1.0)
            border.borderColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1).cgColor
            border.frame = CGRect(x: 0, y: passwordTextField.frame.size.height - width, width:  passwordTextField.frame.size.width + 18, height: passwordTextField.frame.size.height)
            
//            let logoImage = UIImageView(image: UIImage(named: "lock"))
//            logoImage.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            border.borderWidth = width
            passwordTextField.layer.addSublayer(border)
            passwordTextField.layer.masksToBounds = true
//            passwordTextField.leftView = logoImage
//            passwordTextField.leftView?.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
//            passwordTextField.leftViewMode = .always
            passwordTextField.textAlignment = .center
            passwordTextField.textColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)
        }
    }
    
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!{
        didSet{
            confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm password",
                                                                                attributes: [NSForegroundColorAttributeName: UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)])
            confirmPasswordTextField.isSecureTextEntry = true
            confirmPasswordTextField.delegate = self
            
            let border = CALayer()
            let width = CGFloat(1.0)
            border.borderColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1).cgColor
            border.frame = CGRect(x: 0, y: confirmPasswordTextField.frame.size.height - width, width:  confirmPasswordTextField.frame.size.width + 18, height: confirmPasswordTextField.frame.size.height)
            
//            let logoImage = UIImageView(image: UIImage(named: "lock"))
//            logoImage.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            
            border.borderWidth = width
            confirmPasswordTextField.layer.addSublayer(border)
            confirmPasswordTextField.layer.masksToBounds = true
//            confirmPasswordTextField.leftView = logoImage
//            confirmPasswordTextField.leftView?.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
//            confirmPasswordTextField.leftViewMode = .always
            confirmPasswordTextField.textAlignment = .center
            confirmPasswordTextField.textColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)
        }
    }
    
    
    @IBOutlet weak var signUpButton: UIButton!{
        didSet{
            signUpButton.addTarget(self, action: #selector(didTapSignUpButton(_:)), for: .touchUpInside)
            signUpButton.layer.borderWidth = 1
            signUpButton.layer.borderColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1).cgColor
            signUpButton.layer.cornerRadius = 6
            signUpButton.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        }
    }
    
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    var isImageSelected : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpinner()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "Registration"
        self.navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)
]

        myActivityIndicator.color = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
//        self.view.backgroundColor = UIColor(red: 168/255, green: 200/255, blue: 78/255, alpha: 1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if confirmPasswordTextField.isEditing || passwordTextField.isEditing{
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                
                if self.view.frame.origin.y == 0 {
                    
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y != 0 {
                
                self.view.frame.origin.y += keyboardSize.height
            }
        }
        
    }
    
    func imageTapped(sender: UITapGestureRecognizer) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        let alertController = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                pickerController.sourceType = .camera
                self.present(pickerController, animated: true, completion: nil)
            } else {
                let alertVC = UIAlertController(title: "No Camera",message: "Sorry, this device has no camera",preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField{
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField{
            confirmPasswordTextField.resignFirstResponder()
            confirmPasswordTextField.returnKeyType = .done
        }
        return true
    }
    
    func didTapSignUpButton(_ sender: Any){
        self.myActivityIndicator.startAnimating()
        
        guard
            let name = usernameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text
            else { return; }
        
        if name == "" {
            self.warningAlert(warningMessage: "Please enter your username")
            
        } else if password == "" {
            self.warningAlert(warningMessage: "Please enter your password")
            
        } else if password.characters.count < 6  {
            self.warningAlert(warningMessage: "Please enter minimum of 6 characters for password")
            
        } else if email == "" {
            self.warningAlert(warningMessage: "Please enter your email")
            
        } else if password != confirmPassword {
            self.warningAlert(warningMessage: "Please enter your password and confrim password correctly!")
            
        } else if isImageSelected == false {
            self.warningAlert(warningMessage: "Please select profile picture!")
            
        } else {
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if let validError = error {
                    print(validError.localizedDescription)
                    self.warningAlert(warningMessage: "Please enter another email address!")
                    return;
                }
                
                guard let uid = Auth.auth().currentUser?.uid else {return}
                
                let storageRef = Storage.storage().reference()
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                
                let data = UIImageJPEGRepresentation(self.imageView.image!, 0.2)
                
                storageRef.child("\(uid).jpg").putData(data!, metadata: metadata) { (newMeta, error) in
                    if (error != nil) {
                        // Uh-oh, an error occurred!
                        print(error!)
                    } else {
                        
                        defer{
                            self.dismiss(animated: true, completion: nil) //so the return function will return this
                        }
                    }
                    
                    if let foundError = error {
                        print(foundError.localizedDescription)
                        return
                    }
                    
                    guard let imageURL = newMeta?.downloadURLs?.first?.absoluteString else {
                        return
                    }
                    
                    let param : [String : Any] = ["name": name,
                                                  "email": email,
                                                  "profileImageURL": imageURL]
                    
                    let ref = Database.database().reference().child("users")
                    ref.child(uid).setValue(param)
                    
                    
                    UserDefaults.standard.setValue(uid, forKey: "currentUID")
                    UserDefaults.standard.setValue(name, forKey: "currentUserName")
                    let url = URL(string:  imageURL)
                    UserDefaults.standard.set(url, forKey: "currentUserProfileImage")
                    UserDefaults.standard.synchronize()
                }
                
                self.myActivityIndicator.stopAnimating()
                
                print("User sign-up successfully! \(user?.uid ?? "")")
                print("User email address! \(user?.email ?? "")")
                print("Username is \(name)")
            })
        }
    }
    
    func setupSpinner(){
        
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = true
        
        view.addSubview(myActivityIndicator)
    }
    
    func warningAlert(warningMessage: String){
        let alertController = UIAlertController(title: "Error", message: warningMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
        self.myActivityIndicator.stopAnimating()
    }
    
}

extension RegisterVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //media is album , photo is picture. rmb to allow it in plist
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { //cancel button in photo
        self.isImageSelected = false
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.imageView.image = selectedImage
        
        self.isImageSelected = true
        
        dismiss(animated: true, completion: nil)
        
    }
}

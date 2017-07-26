//
//  LoginVC.swift
//  Swipesion
//
//  Created by Andrew Lim on 11/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FBSDKLoginKit

class LoginVC: UIViewController,UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!{
        
        didSet{
            
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes:[NSForegroundColorAttributeName: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)])

            emailTextField.delegate = self
            
            let border = CALayer()
            let width = CGFloat(1.0)
            border.borderColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
            border.frame = CGRect(x: 0, y: emailTextField.frame.size.height - width, width:  emailTextField.frame.size.width + 25, height: emailTextField.frame.size.height)
            
            let logoImage = UIImageView(image: UIImage(named: "email"))
            logoImage.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        
            border.borderWidth = width
            emailTextField.layer.addSublayer(border)
            emailTextField.layer.masksToBounds = true
            emailTextField.leftView = logoImage
            emailTextField.leftView?.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            emailTextField.leftViewMode = .always
            emailTextField.textAlignment = .center
            emailTextField.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                          attributes: [NSForegroundColorAttributeName: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)])
            passwordTextField.isSecureTextEntry = true
            passwordTextField.delegate = self
            passwordTextField.returnKeyType = .done
            
            let border = CALayer()
            let width = CGFloat(1.0)
            border.borderColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
            border.borderWidth = width
            
            border.frame = CGRect(x: 0, y: passwordTextField.frame.size.height - width, width:  passwordTextField.frame.size.width + 25, height: passwordTextField.frame.size.height)
            
            
            let logoImage = UIImageView(image: UIImage(named: "unlock"))
            logoImage.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            
            passwordTextField.layer.addSublayer(border)
            passwordTextField.layer.masksToBounds = true
            passwordTextField.leftView = logoImage
            passwordTextField.leftView?.frame = CGRect(x: 20, y: 20, width: 25, height: 25)
            passwordTextField.leftViewMode = .always
            passwordTextField.textAlignment = .center
            passwordTextField.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)

        }
    }
    
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            loginButton.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
            loginButton.layer.borderWidth = 1
            loginButton.layer.borderColor = UIColor.clear.cgColor
            loginButton.layer.cornerRadius = 6
            loginButton.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton!{
        didSet{
            signUpButton.addTarget(self, action: #selector(didTapRegisterButton(_:)), for: .touchUpInside)
//            signUpButton.layer.borderWidth = 1
//            signUpButton.layer.borderColor = UIColor.black.cgColor
//            signUpButton.layer.cornerRadius = 8
            
        }
    }
    
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!{
        didSet{
            fbLoginButton.delegate = self
        }
    }
    
    
    @IBOutlet weak var logoImageView: UIImageView! {
        
        didSet {
            
//            logoImageView.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        }
    }
    
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpinner()
        myActivityIndicator.color = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        myActivityIndicator.backgroundColor = UIColor.gray
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func didTapRegisterButton(_ sender: Any){
        let storyboard = UIStoryboard(name: "Auth", bundle: Bundle.main)
        let registerVC = storyboard.instantiateViewController(withIdentifier: "RegisterVC")
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    func didTapLoginButton(_ sender: Any){
        myActivityIndicator.startAnimating()
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
            else {
                return;
        }
        
        if emailTextField.text == ""{
            
            self.warningAlert(warningMessage: "Please enter your email")
            
        } else if password == "" || password.characters.count < 6 {
            self.warningAlert(warningMessage: "Please enter your password")
            
        } else {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if let validError = error {
                    print(validError.localizedDescription)
                    self.warningAlert(warningMessage: "Please enter your email or password correctly!")
                    return;
                }
                
                print("User exist \(user?.uid ?? "")")
                
                self.fetchUser()
                UserDefaults.standard.synchronize()
                self.myActivityIndicator.stopAnimating()
                self.emailTextField.text = nil
                self.passwordTextField.text = nil
            })
            
        }
    }
    
    func fetchUser(){
        let ref = Database.database().reference()
        
        if let userID = Auth.auth().currentUser?.uid {
            
            
            ref.child("users").child(userID).observe(.value, with: { (snapshot) in
                if let data = UserProfile(snapshot: snapshot){
                    UserDefaults.standard.setValue(data.userID, forKey: "currentUID")
                    UserDefaults.standard.setValue(data.name, forKey: "currentUserName")
                    UserDefaults.standard.set(data.profileImageURL, forKey: "currentUserProfileImage")
                    UserDefaults.standard.set(data.fbID, forKey: "currentUserFacebookID")
                }
            })
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            
            print(error.localizedDescription)
            fbAlert(message: "Please try again")
            return
            
        } else if (result.isCancelled == true){
            
            print("Cancelled")
            
        } else {
            
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signIn(with: credential) { (user, error) in
                print("user logged in the firebase")
                
                let ref = Database.database().reference(fromURL: "https://swipesion.firebaseio.com/")
                
                guard let uid = user?.uid else {
                    return
                }
                
                let userReference = ref.child("users").child(uid)
                
                let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id,name,email"])
                graphRequest.start(completionHandler: { (connection, result, error) in
                    if error != nil {
                        print("\(String(describing: error))")
                    } else {
                        let values : [String: Any] = result as! [String : Any]
                        
                        userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                            if error != nil {
                                print("\(String(describing: error))")
                                return
                            }
                            self.fetchUser()
                            // no error, so it means we've saved the user into our firebase database successfully
                            print("Save the user successfully into Firebase database")
                        })
                    }
                })
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Facebook logout successfully!")
        fbAlert(message: "Facebook logout successfully!")
    }
    
    func setupSpinner(){
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = true
        view.addSubview(myActivityIndicator)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField{
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    func warningAlert(warningMessage: String){
        let alertController = UIAlertController(title: "Error", message: warningMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
        self.myActivityIndicator.stopAnimating()
        
    }
    
    func fbAlert(message: String){
        let alertController = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
    

    
}

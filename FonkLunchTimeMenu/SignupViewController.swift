//
//  ViewController.swift
//  FonkLunchTimeMenu
//
//  Created by Wilco Wilkens on 2018/03/20.
//  Copyright © 2018 Appulse. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signupButtonHeightFromBottom: NSLayoutConstraint!
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var logoHeight: NSLayoutConstraint!
    
    let spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //code to stay signed in
        /*if Auth.auth().currentUser != nil
        {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "login", sender: self)
            }
        }*/
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignupViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignupViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    
    
    @IBOutlet weak var signupButton: UIButton!
    @IBAction func signUpButton(_ sender: Any) {
        
        spinner.frame = signupButton.frame
        spinner.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        spinner.color = #colorLiteral(red: 0.7019383907, green: 0.6977719665, blue: 0.7142301202, alpha: 1)
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        self.view.addSubview(spinner)
        
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
            
            if error == nil
            {
                self.spinner.removeFromSuperview()
                self.performSegue(withIdentifier: "login", sender: self)
            }
            else
            {
                let alert = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler:{ action in
                    self.spinner.removeFromSuperview()
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBOutlet weak var passwordHideShow: UIButton!
    @IBAction func passwordToggle(_ sender: Any) {
        
        if password.isSecureTextEntry == true
        {
            password.isSecureTextEntry = false
            passwordHideShow.setTitle("hide", for: .normal)
        }
        else
        {
            password.isSecureTextEntry = true
            passwordHideShow.setTitle("show", for: .normal)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.signupButtonHeightFromBottom.constant = keyboardSize.height + 32
            self.logoHeight.constant = 0
            self.topViewHeight.constant = 0
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        signupButtonHeightFromBottom.constant =  32
    }
    
}



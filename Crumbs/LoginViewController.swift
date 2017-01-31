//
//  LoginViewController.swift
//  Crumbs
//
//  Created by Alexander Mason on 11/19/16.
//  Copyright © 2016 NY3. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        handleSignIn()
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        createAccountButtonTapped()
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


    func handleSignIn() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                
                return
            }
            //present next view controller
          
        })
    }
    
    func createAccountButtonTapped() {
    
        let createAccountController = UIAlertController(title: "Create Crumb Account", message: "Create Account", preferredStyle: .alert)
        
        let createAccountAction = UIAlertAction(title: "Create", style: .default) { _ in
            let nameField = createAccountController.textFields![0]
            let emailField = createAccountController.textFields![1]
            let passwordField = createAccountController.textFields![2]
            guard let password = passwordField.text else { return }
            guard let email = emailField.text else { return }
            guard let name = nameField.text else { return }
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                //print("inside create user")
                if error != nil {
                    //print("authorization failed \(error)")
                    return
                }
                guard let uid = user?.uid else {
                    //print("uid failed")
                    return
                }
                //print("right before database")
                let ref = FIRDatabase.database().reference(withPath: "user")
                let user = ref.child(uid)
                let value = ["name": name, "email": email]
                user.updateChildValues(value, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        //print("error updating child values \(error)")
                        return
                    }
                    //print("User ID inside of handleRegister is == \(FIRAuth.auth()?.currentUser?.uid)")
                    self.signInUser(email: email, password: password)
                    OperationQueue.main.addOperation {
                        self.performSegue(withIdentifier: "createAccount", sender: self)
                    }
                })
            })
            print(password)
            print(email)
            print(name)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        createAccountController.addAction(cancelAction)
        createAccountController.addAction(createAccountAction)
        createAccountController.addTextField { (textfield) in
            textfield.placeholder = "Enter name"
        }
        createAccountController.addTextField { (textfield) in
            textfield.placeholder = "Enter email"
        }
        createAccountController.addTextField { (textfield) in
            textfield.placeholder = "Enter password"
            textfield.isSecureTextEntry = true
        }
        self.present(createAccountController, animated: true, completion: nil)
    }
    
    func signInUser(email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                //print("user couldn't login \(error)")
                return
            }
            //print("user signed in")
        })
    }
    

}















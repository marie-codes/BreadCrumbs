//
//  FirebaseLogin.swift
//  Crumbs
//
//  Created by Alexander Mason on 11/19/16.
//  Copyright © 2016 NY3. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebaseLogin {
    
    func handleRegister() {
        //take in name, email, password from textField using guard statements
        let email = "emailPlaceholder"
        let password = "passwordPlaceholder"
        let name = "namePlaceholder"
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print("error is \(error)")
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let ref = FIRDatabase.database().reference(withPath: "user")
            let user = ref.child(uid)
            let values = ["name": name, "email": email]
            user.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print("error updating child values \(error)")
                    return
                }
                print("User ID inside of handleRegister is == \(FIRAuth.auth()?.currentUser?.uid)")
            })
            
            
        })
    }
    
    
    
    
}

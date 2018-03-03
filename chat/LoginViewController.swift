//
//  LoginViewController.swift
//  chat
//
//  Created by Samba on 3/1/18.
//  Copyright © 2018 Samba. All rights reserved.
//

import UIKit
import Parse
class LoginViewController: UIViewController {

    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBAction func signUp(_ sender: Any) {
        if nameField.text == ""
        {
            print("nothing in name")
            let alertController = UIAlertController(title: "Sign Up Error", message: "Username field empty", preferredStyle: .alert)
            // create an OK action
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // handle response here.
            }
            // add the OK action to the alert controller
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else if passField.text == ""
        {
            let alertController = UIAlertController(title: "Sign Up Error", message: "Password field empty", preferredStyle: .alert)
            // create an OK action
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // handle response here.
            }
            // add the OK action to the alert controller
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            let newUser = PFUser()
            newUser.username = nameField.text
            newUser.password = passField.text
            newUser.signUpInBackground(block: { (success, error) -> Void in
                if success {
                    print("liiiiiiit made a user")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }else{
                    print(error?.localizedDescription as Any)
                }
            })
            
        }
        
    }
    
    @IBAction func signIn(_ sender: Any) {
        if nameField.text == ""
        {
            let alertController = UIAlertController(title: "Sign In Error", message: "Username field empty", preferredStyle: .alert)
            // create an OK action
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // handle response here.
            }
            // add the OK action to the alert controller
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else if passField.text == ""
        {
            let alertController = UIAlertController(title: "Sign In Error", message: "Password field empty", preferredStyle: .alert)
            // create an OK action
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // handle response here.
                
            }
            // add the OK action to the alert controller
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            PFUser.logInWithUsername(inBackground: nameField.text!, password: passField.text!, block: { (user, error) -> Void in
                if(user != nil){
                    print("logged in")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
                
            })
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

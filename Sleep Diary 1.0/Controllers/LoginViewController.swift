//
//  ViewController.swift
//  Sleep Diary 1.0
//
//  Created by VIS Swimming on 25/5/18.
//  Copyright © 2018 TOR. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var enterName: UITextField!
    @IBOutlet weak var enterEmail: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true
        self.enterName.delegate = self
        self.enterEmail.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        //check if user is logged in
        if  UserDefaults.standard.bool(forKey: "UserIsLoggedIn") == true {
            let summaryNav = self.storyboard?.instantiateViewController(withIdentifier: "SummaryNavigationController") as! UINavigationController
            self.present(summaryNav, animated: true, completion: nil)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enterEmail.resignFirstResponder()
        enterName.resignFirstResponder()
        return (true)
    }

    @IBOutlet weak var LoginButton: UIButton!
    @IBAction func beginDiaryButtonPressed(_ sender: UIButton) {
        if enterName.text! == "" && enterEmail.text == "" {
            
            UIView.animate(withDuration: 0.2, animations: {
                
                let rightTransform  = CGAffineTransform(translationX: 20, y: 0)
                self.enterEmail.transform = rightTransform
                self.enterName.transform = rightTransform
                
            }) { (_) in
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.enterEmail.transform = CGAffineTransform.identity
                    self.enterName.transform = CGAffineTransform.identity
                })
            }
            
        } else if let email = enterName.text {
            
            UserDefaults.standard.set(true, forKey: "UserIsLoggedIn")
            UserDefaults.standard.set(email, forKey: "UserEmail")
            let summaryVC = self.storyboard?.instantiateViewController(withIdentifier: "SummaryNavigationController") as! UINavigationController
            self.present(summaryVC, animated: true, completion: nil)
            ref = Database.database().reference()
            
            self.ref.child("users").child(email).setValue(["username": email])
        }
    }
}



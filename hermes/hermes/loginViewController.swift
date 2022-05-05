//
//  loginViewController.swift
//  hermes
//
//  Created by Arjun Peri on 11/17/21.
//

import UIKit
import Firebase
import FirebaseAuth



class loginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    var buttonPressed: Int!
    @IBOutlet weak var hermesLogo: UIImageView!
    
    @IBAction func loginButton(_ sender: Any) {
        buttonPressed = 0
        // clean up the user data
        let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        // Signing in the User
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
            } else {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
//        textField.resignFirstResponder() // dismiss keyboard
        return false
    }

    
    
    
    @IBAction func forgotPassword(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: emailText.text!) { error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Password Reset!", message: "A link to reset your password has been sent to your email!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func signupButton(_ sender: Any) {
        buttonPressed = 1
        self.performSegue(withIdentifier: "signUpSegue", sender: nil)
    }
    
    @IBAction func unwindToLogin( segue: UIStoryboardSegue){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordText.delegate = self
        hermesLogo.image = UIImage(named: "logo")
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (buttonPressed == 0){
            let destVC = segue.destination as! mainTabBarController
        }
        else if (buttonPressed == 1){
            let destVC = segue.destination as! signUpViewController
        }
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

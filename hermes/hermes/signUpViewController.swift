//
//  signUpViewController.swift
//  hermes
//
//  Created by Arjun Peri on 11/17/21.
//

import UIKit
import Firebase
import FirebaseAuth

class signUpViewController: UIViewController {

    @IBOutlet weak var signupEmail: UITextField!
    @IBOutlet weak var signupPassword: UITextField!
    
    
    @IBAction func signupButton(_ sender: Any) {
        // clean up the user data
        let email = signupEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = signupPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
            } else {
                self.performSegue(withIdentifier: "signUpSuccessSegue", sender: nil)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! mainTabBarController
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

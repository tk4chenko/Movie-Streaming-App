//
//  AuthenticationViewController.swift
//  TMDbApp
//
//  Created by Artem Tkachenko on 29.10.2022.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    private let viewModel = ViewModelAuthenticationVC()
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var username: String! {
        return usernameField.text
    }
    
    var password: String! {
        return passwordField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        viewModel.createRequestToken { token in
            self.viewModel.createSessionWithLogin(username: self.username, password: self.password, requestToken: token) {
                self.viewModel.createSession(requestToken: token) { session in
                    print(session)
                }
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

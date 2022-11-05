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
                    if session == true {
                        
                    }
                }
            }
        }
    }

}

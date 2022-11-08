//
//  AuthenticationViewController.swift
//  TMDbApp
//
//  Created by Artem Tkachenko on 29.10.2022.
//

import UIKit

var sessionId = String()

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
                    sessionId = session.session_id ?? ""
                    if session.success == true {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "UITabBarController")
                        vc.modalPresentationStyle = .fullScreen
//                        self.dismiss(animated: true)
                        self.present(vc, animated: false)
                    }
                }
            }
        }
        
    }
    
}

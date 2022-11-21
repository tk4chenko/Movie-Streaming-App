//
//  AuthenticationViewController.swift
//  TMDbApp
//
//  Created by Artem Tkachenko on 29.10.2022.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    private let viewModel = ViewModelAuthenticationVC()
    
    @IBOutlet weak var wrongLabel: UILabel!
    @IBOutlet weak var guestSessionButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private var username: String! {
        return usernameField.text
    }
    
    private var password: String! {
        return passwordField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func guestSessionPressed(_ sender: Any) {
        
        viewModel.createGuestSession { session in
            sessionId = session.guestSessionID ?? ""
            
            if session.success == true {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "UITabBarController")
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
            }
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        viewModel.createRequestToken { token in
            self.viewModel.createSessionWithLogin(username: self.username, password: self.password, requestToken: token) {
                self.viewModel.createSession(requestToken: token) { session in
                    self.viewModel.getAccountId(sessionId: session.session_id ?? "") { accountID in
                        accountId = accountID.id ?? 0
                        print(accountID.id ?? 0)
                    }
                    print(session.session_id ?? "")
                    
                    sessionId = session.session_id ?? ""
                    
                    if session.success == true {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "UITabBarController")
                        vc.modalPresentationStyle = .fullScreen
//                        self.dismiss(animated: true)
                        self.present(vc, animated: false)
                    } else {
                        self.wrongLabel.text = "Wrong password or username"
                    }
                }
            }
        }
        
    }
    
}

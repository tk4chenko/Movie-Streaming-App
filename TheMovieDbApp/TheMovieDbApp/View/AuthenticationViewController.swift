//
//  AuthenticationViewController.swift
//  TMDbApp
//
//  Created by Artem Tkachenko on 29.10.2022.
//

import UIKit
import Locksmith

class AuthenticationViewController: UIViewController {
    
    private let viewModel = ViewModelAuthenticationVC()
    
    @IBOutlet weak var wrongLabel: UILabel!
    @IBOutlet weak var guestSessionButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.setTitle("Log in", for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        loginButton.tintColor = .white
        loginButton.backgroundColor = .red
        loginButton.layer.cornerRadius = 25
        configureShadow()
        
    }
    
    private func configureShadow() {
        loginButton.layer.shadowRadius = 5
        loginButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        loginButton.layer.shadowOpacity = 0.5
        loginButton.layer.shadowColor = UIColor.red.cgColor
//        titleLabel.layer.cornerRadius = 6
    }
    
    @IBAction func guestSessionPressed(_ sender: Any) {
        viewModel.createGuestSession { session in
            if session.success == true {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "UITabBarController")
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
            }
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        guard let username = usernameField.text, let password = passwordField.text else { return }
    
        viewModel.createSession(username: username, password: password) { success in
            if success == true {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "UITabBarController")
                vc.modalPresentationStyle = .fullScreen
                self.dismiss(animated: false)
                self.present(vc, animated: false)
            } else {
                self.wrongLabel.text = "Wrong password or username"
            }
        }
    }

}

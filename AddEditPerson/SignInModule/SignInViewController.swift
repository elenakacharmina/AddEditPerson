//
//  SignInViewController.swift
//  AddEditPerson
//
//  Created by Elena Kacharmina on 16.04.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    var presenter: SignInPresenterProtocol!
    
    var emailField: UITextField!
    var passwordField: UITextField!
    
    var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 224/255, green: 255/255, blue: 169/255, alpha: 1)
        
        setupUI()
        createConstraints()
    }
    
    func signInUser(email: String, password: String) {
           presenter.signIn(email: email, password: password)
       }
    
    @objc func loginAction(_ sender: Any) {
        guard let email = emailField.text, let password = passwordField.text else {return}
        if(!email.isEmpty && !password.isEmpty){
            signInUser(email: email, password: password)
        }else{
            showAlert()
        }
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Ошибка", message: "Заполните все поля", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showAuthError(){
        let alert = UIAlertController(title: "Ошибка", message: "Ошибка", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Попробовать ещё раз", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension SignInViewController: SignInViewProtocol {
    func success() {
        presenter.openMain()
    }
    
    func failure(error: Error) {
        showAuthError()
    }
}


extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == emailField){
            let nextField = passwordField!
            nextField.becomeFirstResponder()
        }
        return true
    }
}

// MARK: UI functions

extension SignInViewController {
    func setupUI() {
        emailField = UITextField()
        emailField.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        passwordField = UITextField()
        passwordField.attributedPlaceholder = NSAttributedString(string: "Пароль", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Войти", for: .normal)
        
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        
        [emailField,
         passwordField,
         loginButton].forEach { view.addSubview($0) }
    }
    
    func createConstraints() {
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emailField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 160),
            emailField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emailField.widthAnchor.constraint(equalToConstant: 300),
            emailField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            passwordField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            passwordField.widthAnchor.constraint(equalToConstant: 300),
            passwordField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 16),
            loginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 300),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

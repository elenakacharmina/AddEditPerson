//
//  SignUpViewController.swift
//  AddEditPerson
//
//  Created by Elena Kacharmina on 15.04.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    var presenter: SignUpPresenterProtocol!
    
    var nameField: UITextField!
    var emailField: UITextField!
    var passwordField: UITextField!
    
    var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 224/255, green: 255/255, blue: 169/255, alpha: 1)
        
        setupUI()
        createConstraints()
    }
    
    @objc func registerAction(_ sender: Any) {
        guard let name = nameField.text, let email = emailField.text, let password = passwordField.text else {return}
        if(!name.isEmpty && !email.isEmpty && !password.isEmpty){
            self.presenter.signUp(name: name, email: email, password: password)
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

extension SignUpViewController: SignUpViewProtocol {
    func success() {
        presenter.openMain()
    }
    
    func failure(error: Error) {
        showAuthError()
    }
    
    
}


extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == nameField){
            let nextField = emailField!
            nextField.becomeFirstResponder()
        } else if (textField == emailField){
            let nextField = passwordField!
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}

//MARK: UI functions

extension SignUpViewController {
    func setupUI() {
        nameField = UITextField()
        nameField.attributedPlaceholder = NSAttributedString(string: "Имя пользователя", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        nameField.delegate = self
        
        
        emailField = UITextField()
        emailField.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        emailField.delegate = self
        
        passwordField = UITextField()
        passwordField.attributedPlaceholder = NSAttributedString(string: "Пароль", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordField.delegate = self
        
        registerButton = UIButton(type: .system)
        registerButton.setTitle("Зарегистрироваться", for: .normal)
        
        registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        
        [nameField,
        emailField,
        passwordField,
        registerButton].forEach { view.addSubview($0) }
    }
    
    func createConstraints() {
        nameField.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            nameField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            nameField.widthAnchor.constraint(equalToConstant: 300),
            nameField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            emailField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 16),
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
            registerButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 16),
            registerButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            registerButton.widthAnchor.constraint(equalToConstant: 300),
            registerButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

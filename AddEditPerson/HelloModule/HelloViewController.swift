//
//  HelloViewController.swift
//  AddEditPerson
//
//  Created by Elena Kacharmina on 15.04.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import UIKit

class HelloViewController: UIViewController {
    
    var label: UILabel!
    
    var signUpButton: UIButton!
    var signInButton: UIButton!
    var goOnButton: UIButton!
    
    var presenter: HelloPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 224/255, green: 255/255, blue: 169/255, alpha: 1)
        
        setupUI()
        createConstraints()
    }
    
    // MARK: Button actions
    
    @objc func signUpAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        presenter.openSignUp()
    }
    
    @objc func signInAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        presenter.openSignIn()
    }
    @objc func goOnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        presenter.openGoOn()
    }
}

// MARK: UI functions

extension HelloViewController {
    func setupUI() {
        
        label = UILabel()
        label.text = "Add & edit person application"
        label.font = UIFont(name: "Palatino", size: 24)
        label.textAlignment = .center
//        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        
        
        signUpButton = UIButton(type: .system)
        signUpButton.setTitle("Зарегистрироваться", for: .normal)
        signUpButton.layer.borderColor = UIColor.systemGray.cgColor
        signUpButton.layer.borderWidth = 0.5
        
        signUpButton.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
        
        signInButton = UIButton(type: .system)
        signInButton.setTitle("Войти", for: .normal)
        signInButton.layer.borderColor = UIColor.systemGray.cgColor
        signInButton.layer.borderWidth = 0.5
        
        signInButton.addTarget(self, action: #selector(signInAction), for: .touchUpInside)
        
        goOnButton = UIButton(type: .system)
        goOnButton.setTitle("Продолжить без регистрации", for: .normal)
        goOnButton.layer.borderColor = UIColor.systemGray.cgColor
        goOnButton.layer.borderWidth = 0.5
        
        goOnButton.addTarget(self, action: #selector(goOnAction), for: .touchUpInside)
        
        view.addSubview(signUpButton)
        view.addSubview(signInButton)
        view.addSubview(goOnButton)
        view.addSubview(label)
    }
    
    func createConstraints() {
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        goOnButton.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            label.widthAnchor.constraint(equalToConstant: 300),
            label.heightAnchor.constraint(equalToConstant: 70),
            
            signUpButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            signUpButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalToConstant: 230),
            signUpButton.heightAnchor.constraint(equalToConstant: 40),
            
            signInButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 30),
            signInButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            signInButton.widthAnchor.constraint(equalToConstant: 230),
            signInButton.heightAnchor.constraint(equalToConstant: 40),
            
            goOnButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 30),
            goOnButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            goOnButton.widthAnchor.constraint(equalToConstant: 230),
            goOnButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

extension HelloViewController: HelloViewProtocol {
    
}

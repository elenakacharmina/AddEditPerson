//
//  SignUpPresenter.swift
//  AddEditPerson
//
//  Created by Elena Kacharmina on 15.04.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import Firebase

protocol SignUpViewProtocol: class {
    func success()
    func failure(error: Error)
}

protocol SignUpPresenterProtocol: class {
    init(view: SignUpViewProtocol, root: RootViewProtocol)
    func signUp(name: String, email: String, password: String)
    func openMain()
}


class SignUpPresenter: SignUpPresenterProtocol {
    
    weak var view: SignUpViewProtocol?
    var root: RootViewProtocol?
    
    required init(view: SignUpViewProtocol, root: RootViewProtocol) {
        self.view = view
        self.root = root
    }
    
    func signUp(name: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil{
                if let result = result {
                    let ref = Database.database().reference().child("users")
                    ref.child(result.user.uid).updateChildValues(["name": name, "email": email])
                }
                self.view?.success()
            }
            else{
                self.view?.failure(error: error!)
            }
        }
    }
    
    func openMain() {
        root?.showMainView()
    }
}

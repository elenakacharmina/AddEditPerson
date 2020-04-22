//
//  SignInPresenter.swift
//  AddEditPerson
//
//  Created by Elena Kacharmina on 16.04.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import Foundation
import Firebase

protocol SignInViewProtocol: class {
    func signInUser(email: String, password: String)
    func success()
    func failure(error: Error)
}

protocol SignInPresenterProtocol: class {
    init(view: SignInViewProtocol, root: RootViewProtocol)
    func signIn(email: String, password: String)
    func openMain()
    func pop()
}


class SignInPresenter: SignInPresenterProtocol {
    
    weak var view: SignInViewProtocol?
    var root: RootViewProtocol?
    
    required init(view: SignInViewProtocol, root: RootViewProtocol) {
        self.view = view
        self.root = root
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil{
                self.view?.success()
            }else{
                self.view?.failure(error: error!)
            }
        }
    }
    
    func openMain() {
        root?.showMainView()
    }
    
    func pop() {
        root?.popToRoot()
    }
    
}

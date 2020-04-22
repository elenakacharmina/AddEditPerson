//
//  SplashPresenter.swift
//  AddEditPerson
//
//  Created by Elena Kacharmina on 15.04.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import Foundation
import Firebase

protocol SplashViewProtocol: class {
    func success()
    func failure()
}

protocol SplashPresenterProtocol: class {
    init(view: SplashViewProtocol, root: RootViewProtocol)

    func openHelloView()
    func openMainView()
    func checkSignIn()
}


class SplashPresenter: SplashPresenterProtocol {
    weak var view: SplashViewProtocol?
    var root: RootViewProtocol?
    
    required init(view: SplashViewProtocol, root: RootViewProtocol) {
        self.view = view
        self.root = root
    }
    
    func checkSignIn() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil{
                self.view?.failure()
            }else{
                self.view?.success()
            }
        }
    }
    
    func openHelloView() {
        root?.showHelloView()
    }
    
    func openMainView() {
        root?.showMainView()
    }
}



    

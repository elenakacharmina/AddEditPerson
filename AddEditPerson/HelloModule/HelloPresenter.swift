//
//  HelloPresenter.swift
//  AddEditPerson
//
//  Created by Elena Kacharmina on 15.04.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import Foundation

protocol HelloViewProtocol: class {
    
}

protocol HelloPresenterProtocol: class {
    init(view: HelloViewProtocol, root: RootViewProtocol)
    func openSignUp()
    func openSignIn()
    func openGoOn()
}


class HelloPresenter: HelloPresenterProtocol {
    
    weak var view: HelloViewProtocol?
    var root: RootViewProtocol?
    
    required init(view: HelloViewProtocol, root: RootViewProtocol) {
        self.view = view
        self.root = root
    }
    func openSignUp() {
        root?.showSignUp()
    }
    
    func openSignIn() {
        root?.showSignIn()
    }
    
    func openGoOn() {
        root?.showMainView()
    }
    
    
}

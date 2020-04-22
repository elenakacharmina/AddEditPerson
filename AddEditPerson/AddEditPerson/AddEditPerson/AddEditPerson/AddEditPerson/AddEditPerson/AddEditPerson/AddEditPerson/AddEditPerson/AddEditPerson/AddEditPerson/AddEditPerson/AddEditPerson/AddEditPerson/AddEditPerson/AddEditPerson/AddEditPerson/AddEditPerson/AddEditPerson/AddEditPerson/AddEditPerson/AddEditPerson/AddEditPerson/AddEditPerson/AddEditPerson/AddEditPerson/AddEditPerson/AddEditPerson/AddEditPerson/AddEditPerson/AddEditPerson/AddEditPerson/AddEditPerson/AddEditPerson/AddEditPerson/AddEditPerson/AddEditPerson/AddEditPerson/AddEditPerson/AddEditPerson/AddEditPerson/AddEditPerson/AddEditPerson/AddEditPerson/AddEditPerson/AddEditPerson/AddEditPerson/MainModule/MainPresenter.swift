//
//  MainPresenter.swift
//  AddEditPerson
//
//  Created by Elena Kacharmina on 15.04.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import Foundation

protocol MainViewProtocol: class {
//    var presenter: MainPresenterProtocol? {get set}
}

protocol MainPresenterProtocol: class {
    init(view: MainViewProtocol, router: RouterProtocol)
    
}


class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    var router: RouterProtocol?
    
    required init(view: MainViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    
}

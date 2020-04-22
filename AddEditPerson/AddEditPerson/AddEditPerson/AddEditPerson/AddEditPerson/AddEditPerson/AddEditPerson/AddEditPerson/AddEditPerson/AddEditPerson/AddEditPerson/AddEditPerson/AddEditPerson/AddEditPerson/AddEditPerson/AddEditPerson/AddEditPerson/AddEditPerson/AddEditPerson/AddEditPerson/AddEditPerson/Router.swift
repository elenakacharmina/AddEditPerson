//
//  Router.swift
//  AddEditPerson
//
//  Created by Elena Kacharmina on 15.04.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import UIKit


protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func showFirstView()
//    func initialViewController()
//    func showLogin()
//    func showSignUp()
//    func popToRoot()
//    func showContent()
//    func showAboutUs()
}

class Router: RouterProtocol {
    
    
    var navigationController: UINavigationController?
    
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init (navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol){
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func showFirstView() {
        if let navigationController = navigationController {
            guard let introViewController = assemblyBuilder?.createFirstModule(router: self) else { return }
            navigationController.viewControllers = [introViewController]
        }
    }
    
}

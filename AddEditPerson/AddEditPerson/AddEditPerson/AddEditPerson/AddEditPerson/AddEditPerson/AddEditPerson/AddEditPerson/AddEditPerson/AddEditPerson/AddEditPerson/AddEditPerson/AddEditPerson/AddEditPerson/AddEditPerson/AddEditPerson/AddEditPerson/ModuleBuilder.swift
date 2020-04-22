//
//  ModuleBuilder.swift
//  AddEditPerson
//
//  Created by Elena Kacharmina on 15.04.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import Foundation
import UIKit

protocol AssemblyBuilderProtocol {
    func createFirstModule(router: RouterProtocol) -> UIViewController
//    func createLoginModule(router: RouterProtocol) -> UIViewController
//    func createContentModule(router: RouterProtocol) -> UIViewController
//    func createSignUpModule(router: RouterProtocol) -> UIViewController
//
//    func createAboutUsModule(router: RouterProtocol) -> UIViewController
    //func createAuthModule(router: RouterProtocol) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    func createFirstModule(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
        let presenter = MainPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
    
    
}

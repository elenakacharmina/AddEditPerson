//
//  RootViewController.swift
//  AddEditPerson
//
//  Created by Elena Kacharmina on 15.04.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import UIKit

protocol RootViewProtocol {
    var current: UIViewController! {get set}
    func showHelloView()
    func showSignUp()
    func showSignIn()
    func showMainView()
    func popToRoot()
}

//protocol currentViewProtocol {
//    var presenter:
//}

class RootViewController: UIViewController {
    
    var current: UIViewController!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        current = SplashViewController()
        
        let splashViewController = SplashViewController()
        let presenter = SplashPresenter(view: splashViewController, root: self)
        splashViewController.presenter = presenter
        
        current = splashViewController
        
        //        if let vc = current as? SplashViewController {
        //            let presenter = SplashPresenter(view: vc, root: self)
        //            vc.presenter = presenter
        //        }
        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RootViewController: RootViewProtocol {
    func showHelloView() {
        let helloViewController = HelloViewController()
        let new = UINavigationController(rootViewController: helloViewController)
        let presenter = HelloPresenter(view: helloViewController, root: self)
        helloViewController.presenter = presenter
        
        addChild(new)
        new.view.frame = view.bounds
        view.addSubview(new.view)
        new.didMove(toParent: self)
        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        current = new
    }
    
    func showSignUp() {
        let view = SignUpViewController()
        let presenter = SignUpPresenter(view: view, root: self)
        view.presenter = presenter
        
        guard let navController = current as? UINavigationController else {return}
        navController.pushViewController(view, animated: true)
    }
    
    func showSignIn() {
        let view = SignInViewController()
        let presenter = SignInPresenter(view: view, root: self)
        view.presenter = presenter
        
        guard let navController = current as? UINavigationController else {return}
        navController.pushViewController(view, animated: true)
    }
    
    func showMainView() {
        let containerViewController = ContainerViewController()
        containerViewController.root = self
        
//        let centerViewController = CenterViewController()
//        let presenter = MainPresenter(view: centerViewController, root: self)
//        centerViewController.presenter = presenter
////        centerViewController.delegate
        current.willMove(toParent: nil)
        addChild(containerViewController)
        
//        let centerNavigationController = UINavigationController(rootViewController: centerViewController)
//        current.willMove(toParent: nil)
//        addChild(centerNavigationController)
        
        transition(from: current, to: containerViewController, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
        }) { completed in
            self.current.removeFromParent()
            containerViewController.didMove(toParent: self)
            self.current = containerViewController
            //             completion?()  //1
        }
//        let mainViewController = MainViewController()
//        let mainScreen = UINavigationController(rootViewController: mainViewController)
//        let presenter = MainPresenter(view: mainViewController, root: self)
//        mainViewController.presenter = presenter
//
////        addChild(mainScreen)
////        mainScreen.view.frame = view.bounds
////        view.addSubview(mainScreen.view)
////        mainScreen.didMove(toParent: self)
////        current.willMove(toParent: nil)
////        current.view.removeFromSuperview()
////        current.removeFromParent()
////        current = mainScreen
//
//
//        current.willMove(toParent: nil)
//        addChild(mainScreen)
//
//        transition(from: current, to: mainScreen, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
//        }) { completed in
//            self.current.removeFromParent()
//            mainScreen.didMove(toParent: self)
//             self.current = mainScreen
////             completion?()  //1
//        }
    }
    
    func popToRoot() {
//        guard let navController = current as? UINavigationController else {return}
//        navController.popToRootViewController(animated: true)
        showHelloView()
    }
}

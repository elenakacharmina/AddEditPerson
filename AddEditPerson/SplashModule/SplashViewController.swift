//
//  SplashViewController.swift
//  AddEditPerson
//
//  Created by Elena Kacharmina on 15.04.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    var presenter: SplashPresenterProtocol!
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(activityIndicator)
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.4)
        makeServiceCall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.frame = view.bounds
    }
    private func makeServiceCall() {
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) { [weak self] in
            self?.presenter.checkSignIn()
        }
    }
}

extension SplashViewController: SplashViewProtocol {
    func success() {
        activityIndicator.stopAnimating()
        presenter.openMainView()
    }
    
    func failure() {
        activityIndicator.stopAnimating()
        presenter.openHelloView()
    }
}

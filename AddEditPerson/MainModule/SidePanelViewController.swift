//
//  SidePanelViewController.swift
//  AddEditPerson
//
//  Created by Elena Kacharmina on 16.04.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import UIKit
import Firebase

class SidePanelViewController: UIViewController {
    
    var nameLabel: UILabel!
    
    var editButton: UIButton!
    var viewButton: UIButton!
    var infoButton: UIButton!
    var logOutButton: UIButton!
    
    var delegate: SidePanelViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        createConstraints()
    }
    
    private func setName() {
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
//        nameLabel.text = "Пользователь: "
//        var string = ""
        guard let id = userID else {
            nameLabel.text = "Пользователь"
            return }
        
        ref.child("users").child(id).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            let value = snapshot.value as? NSDictionary
//            string = value?["name"] as? String ?? ""
//            self?.nameLabel.text! += string
            self?.nameLabel.text = value?["name"] as? String ?? ""
        })
    }
    
    //MARK: Button actions
    
    @objc func editPressed(_ sender: Any) {
        delegate?.changeCenterView(to: .editMode, objectIndex: nil)
    }
    
    @objc func viewPressed(_ sender: Any) {
        delegate?.changeCenterView(to: .viewMode, objectIndex: nil)
    }
    
    @objc func infoPressed(_ sender: Any) {
        delegate?.changeCenterView(to: .infoMode, objectIndex: nil)
    }
    
    @objc func logOutPressed(_ sender: Any) {
        delegate?.logOut()
    }    
}

protocol SidePanelViewControllerDelegate {
    func changeCenterView(to newMode: CenterViewMode, objectIndex: Int?)
    func logOut()
}

enum CenterViewMode {
    case editMode
    case viewMode
    case infoMode
}

// MARK: UI functions

extension SidePanelViewController {
    private func createUI() {
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        nameLabel.textAlignment = .center
        
        setName()
        
        editButton = UIButton(type: .system)
        editButton.setTitle("Редактирование", for: .normal)
        editButton.addTarget(self, action: #selector(editPressed), for: .touchUpInside)
        
        viewButton = UIButton(type: .system)
        viewButton.setTitle("Просмотр", for: .normal)
        viewButton.addTarget(self, action: #selector(viewPressed), for: .touchUpInside)
        
        infoButton = UIButton(type: .system)
        infoButton.setTitle("О программе", for: .normal)
        infoButton.addTarget(self, action: #selector(infoPressed), for: .touchUpInside)
        
        logOutButton = UIButton(type: .system)
        logOutButton.setTitle("Выйти из аккаунта", for: .normal)
        logOutButton.setTitleColor(.red, for: .normal)
        logOutButton.addTarget(self, action: #selector(logOutPressed), for: .touchUpInside)
        
        [nameLabel,
         editButton,
         viewButton,
         infoButton,
         logOutButton].forEach { view.addSubview($0) }
    }
    
    private func createConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        viewButton.translatesAutoresizingMaskIntoConstraints = false
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            nameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 300),
            nameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 32),
            editButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 300),
            editButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            viewButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 16),
            viewButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            viewButton.widthAnchor.constraint(equalToConstant: 300),
            viewButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            infoButton.topAnchor.constraint(equalTo: viewButton.bottomAnchor, constant: 16),
            infoButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            infoButton.widthAnchor.constraint(equalToConstant: 300),
            infoButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            logOutButton.topAnchor.constraint(equalTo: infoButton.bottomAnchor, constant: 16),
            logOutButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logOutButton.widthAnchor.constraint(equalToConstant: 300),
            logOutButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

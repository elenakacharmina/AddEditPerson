//
//  ViewModeViewController.swift
//  AddEditPerson
//
//  Created by Elena Kacharmina on 17.04.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import UIKit

class ViewModeViewController: UIViewController {
    
    var delegate: CenterViewControllerDelegate?
    
    var customIdentifier = "ObjectTableViewCell"
    
    var objects: [[String:String]] = []
    
    var tableView: UITableView!
    var objectIndex: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 248/255, green: 233/255, blue: 208/255, alpha: 1)
        
        createUI()
        createConstraints()

        getObjects()
    }
    
    func getObjects() {
        objects = []
        var fileName = delegate?.userID ?? "testUserID"
        fileName += ".json"
        
        guard let fileURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(fileName) else { return }
        
        if let data = try? Data(contentsOf: fileURL),
            let result = try? JSONSerialization.jsonObject(with: data),
            let dictionaryResult = result as? [[String : String]] {
            for i in dictionaryResult {
                objects.append(i)
            }
        }
    }
    
    // MARK: Button actions
    
    @objc func menuTapped(_ sender: Any) {
        delegate?.toggleLeftPanel()
    }
}


extension ViewModeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var title = objects[indexPath.row]["Name"] ?? ""
        title += ", "
        title += objects[indexPath.row]["Age"] ?? ""
        
        var other = ""
        var counter = 0
        
        for i in objects[indexPath.row] {
            if i.key != "Name" && i.key != "Age" {
                other += i.key + ": " + i.value + "\n"
                counter += 1
            }
            if counter == 2 {
                other.removeLast()
                break
            }
        }
        
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: customIdentifier, for: indexPath)
        if let customTableViewCell = tableViewCell as? ObjectTableViewCell {
            customTableViewCell.fillCell(title: title, other: other)
        }
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.changeCenterView(to: .editMode, objectIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: Protocol

protocol ViewModeDelegateProtocol {
    func changeCenterView(to newMode: CenterViewMode, objectIndex: Int?)
}

// MARK: UI functions

extension ViewModeViewController {
    private func createUI() {
        
        let button = UIButton(type: .system)
        button.setTitle("menu", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)

        tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib.init(nibName: customIdentifier, bundle: nil), forCellReuseIdentifier: customIdentifier)
        
        view.addSubview(tableView)
    }
    
    private func createConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


extension ViewModeViewController: CenterViewProtocol {
}



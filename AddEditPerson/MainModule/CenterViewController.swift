//
//  CenterViewController.swift
//  AddEditPerson
//
//  Created by Elena Kacharmina on 16.04.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import UIKit

class CenterViewController: UIViewController {
    var labelName: UILabel!
    var textFieldName: UITextField!
    
    var labelAge: UILabel!
    var textFieldAge: UITextField!
    
    var labelFirst: UILabel!
    var labelSecond: UILabel!
    
    var stackVerticalView: UIStackView!
    var stackedInfoView: UIStackView!
    
    var scrollView: UIScrollView!
    
    var addButton: UIButton!
    var saveButton: UIButton!
    var deleteButton: UIButton!
    
    var delegate: CenterViewControllerDelegate?
    
    var objectIndex: Int?
    var dictArray = [[String:String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 248/255, green: 233/255, blue: 208/255, alpha: 1)
        createUI()
        createConstraints()
        
        if let objectIndex = objectIndex {
            fillData(objectIndex: objectIndex)
        }
    }
    
    // MARK: Button actions
    
    @objc func menuTapped(_ sender: Any) {
        delegate?.toggleLeftPanel()
    }
    
    @objc func deleteAttrPressed(_ sender: Any) {
        guard let index = objectIndex else {
            showErrorAlert()
            return
        }
        
        dictArray = []
        var fileName = delegate?.userID ?? "testUserID"
        fileName += ".json"
        
        guard let fileURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(fileName) else { return }
        
        if let data = try? Data(contentsOf: fileURL),
            let result = try? JSONSerialization.jsonObject(with: data),
            let dictionaryResult = result as? [[String : String]] {
            for i in dictionaryResult {
                dictArray.append(i)
            }
        }
        dictArray.remove(at: index)
        
        do{
            try JSONSerialization.data(withJSONObject: dictArray).write(to: fileURL)
        } catch {
            print(error)
        }
        objectIndex = nil
        showSomeAlert(message: "Удалено!")
    }
    
    @objc func addAttrPressed() {
        
        let newTextFieldLeft = UITextField()
        newTextFieldLeft.attributedPlaceholder = NSAttributedString(string: "some attribute", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        newTextFieldLeft.borderStyle = .roundedRect
        newTextFieldLeft.backgroundColor = .white
        newTextFieldLeft.delegate = self
        
        let newTextFieldRight = UITextField()
        newTextFieldRight.attributedPlaceholder = NSAttributedString(string: "attribute value", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        newTextFieldRight.borderStyle = .roundedRect
        newTextFieldRight.backgroundColor = .white
        newTextFieldRight.delegate = self
        
        NSLayoutConstraint.activate([
            newTextFieldLeft.heightAnchor.constraint(equalToConstant: 30),
            newTextFieldLeft.widthAnchor.constraint(equalToConstant: 150),
            newTextFieldRight.heightAnchor.constraint(equalToConstant: 30),
            newTextFieldRight.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        stackedInfoView = UIStackView(arrangedSubviews: [newTextFieldLeft, newTextFieldRight])
        stackedInfoView.axis = .horizontal
        stackedInfoView.distribution = .equalSpacing
        stackedInfoView.alignment = .center
        stackedInfoView.spacing = 30.0
        stackVerticalView.addArrangedSubview(stackedInfoView)
    }

    @objc func savePressed(_ sender: Any) {
        
        var dictionary: [String: String] = [:]
        
        dictArray = []
        
        for i in 1..<3{
            guard let stack = stackVerticalView.subviews[i] as? UIStackView,
                let fieldFirst = stack.subviews[0] as? UILabel,
                let fieldSecond = stack.subviews[1] as? UITextField,
                let textSecond = fieldSecond.text else { return}
            if textSecond.isEmpty {
                showEmptyAlert()
                return
            }
            dictionary[fieldFirst.text!] = textSecond
        }
        if stackVerticalView.subviews.count > 3 {
            for i in 3..<stackVerticalView.subviews.count{
                guard let stack = stackVerticalView.subviews[i] as? UIStackView,
                    let fieldFirst = stack.subviews[0] as? UITextField,
                    let fieldSecond = stack.subviews[1] as? UITextField,
                    let textSecond = fieldSecond.text,
                    let textFirst = fieldFirst.text else { return}
                if textFirst.isEmpty || textSecond.isEmpty {
                    showEmptyAlert()
                    return
                }
                dictionary[textFirst] = textSecond
            }
        }
        
        var fileName = delegate?.userID ?? "testUserID"
        fileName += ".json"
        
        if let fileURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(fileName) {
            
            if let data = try? Data(contentsOf: fileURL)  {
                
                if let result = try? JSONSerialization.jsonObject(with: data) {
                    if let dictionaryResult = result as? [[String : String]] {
                        print(dictionaryResult)
                        for i in dictionaryResult {
                            dictArray.append(i)
                        }
                    }
                }
            } else {
                do {
                    try JSONSerialization.data(withJSONObject: dictArray).write(to: fileURL)
                } catch {
                    print(error)
                }
            }
            
            if objectIndex == nil {
                objectIndex = dictArray.count
                dictArray.append(dictionary)
            } else {
                dictArray.remove(at: objectIndex!)
                dictArray.insert(dictionary, at: objectIndex!)
            }
            
            do {
                try JSONSerialization.data(withJSONObject: dictArray).write(to: fileURL)
            } catch {
                print(error)
            }
            showSomeAlert(message: "Сохранено!")
        }
    }

    
    // MARK: Alert
    
    func showErrorAlert() {
           let errorAlert = UIAlertController(title: "Не удалось удалить объект", message: "Данный объект еще не был сохранен", preferredStyle: .alert)
           
           errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(errorAlert, animated: true, completion: nil)
       }
       
       func showEmptyAlert() {
           let errorAlert = UIAlertController(title: "Ошибка сохранения", message: "Заполните все поля", preferredStyle: .alert)
           
           errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(errorAlert, animated: true, completion: nil)
       }
       
       
       func showSomeAlert(message: String) {
           let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
           
           present(alert, animated: true, completion: nil)
           
           let when = DispatchTime.now() + 1
           DispatchQueue.main.asyncAfter(deadline: when){
               alert.dismiss(animated: true, completion: nil)
           }
       }
    
    func fillData(objectIndex: Int) {
        var fileName = delegate?.userID ?? "testUserID"
        fileName += ".json"
        
        var dictionary = [String:String]()
        
        guard let fileURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(fileName) else { return}
        
        guard let data = try? Data(contentsOf: fileURL),
            let result = try? JSONSerialization.jsonObject(with: data),
            let dictionaryResult = result as? [[String : String]] else { return }
        
        print(dictionaryResult)
        dictionary = dictionaryResult[objectIndex]
        
        for i in 1..<3{
            guard let stack = stackVerticalView.subviews[i] as? UIStackView,
                let fieldFirst = stack.subviews[0] as? UILabel,
                let fieldSecond = stack.subviews[1] as? UITextField,
                let textFirst = fieldFirst.text else { return}
            if let value = dictionary[textFirst] {
                fieldSecond.text = value
                dictionary.removeValue(forKey: textFirst)
            }
        }
        
        if dictionary.count > 0 {
            for i in dictionary {
                addAttrPressed()
                guard let stack = stackVerticalView.subviews[stackVerticalView.subviews.count - 1] as? UIStackView,
                    let fieldFirst = stack.subviews[0] as? UITextField,
                    let fieldSecond = stack.subviews[1] as? UITextField else { return}
                fieldFirst.text = i.key
                fieldSecond.text = i.value
            }
        }
    }
}

// MARK: UI functions

extension CenterViewController {
    private func createUI() {
        let button = UIButton(type: .system)
        button.setTitle("menu", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        addButton = UIButton(type: .system)
        addButton.backgroundColor = .white
        addButton.setTitle("Добавить атрибут", for: .normal)
        addButton.setTitleColor(.systemBlue, for: .normal)
        
        addButton.addTarget(self, action: #selector(addAttrPressed), for: .touchUpInside)
        
        saveButton = UIButton(type: .system)
        saveButton.backgroundColor = .white
        saveButton.setTitle("Сохранить объект", for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        
        saveButton.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        
        deleteButton = UIButton(type: .system)
        deleteButton.backgroundColor = .white
        deleteButton.setTitle("Удалить объект", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        
        deleteButton.addTarget(self, action: #selector(deleteAttrPressed), for: .touchUpInside)
        
        labelName = UILabel()
        labelName.text = "Name"
        labelName.textAlignment = .center
        
        textFieldName = UITextField()
        textFieldName.attributedPlaceholder = NSAttributedString(string: "Enter name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textFieldName.borderStyle = .roundedRect
        textFieldName.delegate = self
        
        labelAge = UILabel()
        labelAge.text = "Age"
        labelAge.textAlignment = .center
        
        textFieldAge = UITextField()
        textFieldAge.attributedPlaceholder = NSAttributedString(string: "Enter age", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textFieldAge.borderStyle = .roundedRect
        textFieldAge.delegate = self
        textFieldAge.delegate = self
        
        labelFirst = UILabel()
        labelFirst.text = "Название атрибута"
        labelFirst.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        labelFirst.textAlignment = .center
        
        labelSecond = UILabel()
        labelSecond.text = "Значение атрибута"
        labelSecond.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        labelSecond.textAlignment = .center
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.bounds.height - 190))
        
        scrollView.isScrollEnabled = true
        
        stackVerticalView = UIStackView()
        stackVerticalView.axis = .vertical
        stackVerticalView.distribution = .equalSpacing
        stackVerticalView.alignment = .center
        stackVerticalView.spacing = 40.0
        
        stackedInfoView = UIStackView(arrangedSubviews: [labelFirst, labelSecond])
        stackedInfoView.axis = .horizontal
        stackedInfoView.distribution = .equalSpacing
        stackedInfoView.alignment = .center
        stackedInfoView.spacing = 30.0
        
        stackVerticalView.addArrangedSubview(stackedInfoView)
        
        stackedInfoView = UIStackView(arrangedSubviews: [labelName, textFieldName])
        stackedInfoView.axis = .horizontal
        stackedInfoView.distribution = .equalSpacing
        stackedInfoView.alignment = .center
        stackedInfoView.spacing = 30.0
        
        stackVerticalView.addArrangedSubview(stackedInfoView)

        stackedInfoView = UIStackView(arrangedSubviews: [labelAge, textFieldAge])
        stackedInfoView.axis = .horizontal
        stackedInfoView.distribution = .equalSpacing
        stackedInfoView.alignment = .center
        stackedInfoView.spacing = 30.0
        
        stackVerticalView.addArrangedSubview(stackedInfoView)
    
        scrollView.addSubview(stackVerticalView)
        
        [scrollView,
        addButton,
        saveButton,
        deleteButton].forEach { view.addSubview($0) }
    }
    
    private func createConstraints() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        stackVerticalView.translatesAutoresizingMaskIntoConstraints = false
        
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelAge.translatesAutoresizingMaskIntoConstraints = false
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        textFieldAge.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -8),
            addButton.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 8),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            saveButton.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            deleteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            deleteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
        
        NSLayoutConstraint.activate([
            stackVerticalView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackVerticalView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackVerticalView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            stackVerticalView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            labelName.heightAnchor.constraint(equalToConstant: 30),
            labelName.widthAnchor.constraint(equalToConstant: 150),
            labelAge.heightAnchor.constraint(equalToConstant: 30),
            labelAge.widthAnchor.constraint(equalToConstant: 150),
            
            textFieldName.heightAnchor.constraint(equalToConstant: 30),
            textFieldName.widthAnchor.constraint(equalToConstant: 150),
            textFieldAge.heightAnchor.constraint(equalToConstant: 30),
            textFieldAge.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
}

// MARK: - UITextFieldDelegate

extension CenterViewController: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
//    {
//        let allowedCharacters = CharacterSet.decimalDigits
//        let characterSet = CharacterSet(charactersIn: string)
//        return allowedCharacters.isSuperset(of: characterSet)
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Protocols

protocol CenterViewControllerDelegate {
    func toggleLeftPanel()
    func collapseSidePanels()
    func changeCenterView(to newMode: CenterViewMode, objectIndex: Int?)
//    func logOut()
    
    var userID: String? {get}
    var leftViewController: SidePanelViewController? {get}
}

protocol CenterViewProtocol: UIViewController {
    var delegate: CenterViewControllerDelegate? {get set}
}

extension CenterViewController: CenterViewProtocol {
}



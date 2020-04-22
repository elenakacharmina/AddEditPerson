//
//  AboutAppViewController.swift
//  AddEditPerson
//
//  Created by Elena Kacharmina on 22.04.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import UIKit

class AboutAppViewController: UIViewController {
    
    var delegate: CenterViewControllerDelegate?
    
    var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 248/255, green: 233/255, blue: 208/255, alpha: 1)
        
        createUI()
        createConstraints()
        
    }

    // MARK: Button actions
    
    @objc func menuTapped(_ sender: Any) {
        delegate?.toggleLeftPanel()
    }
    
    // MARK: UI functions
    
    private func createUI() {
        let button = UIButton(type: .system)
        button.setTitle("menu", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)

        textView = UITextView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.bounds.height - 60))
        textView.backgroundColor = UIColor(red: 248/255, green: 233/255, blue: 208/255, alpha: 1)
        
        
        textView.alwaysBounceVertical = true
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        
        let string = """
        Данное приложение реализует следующую последовательсть: \n1. Форма проверки логина и пароля с индикатором выполнения и проверки введённых данных; \n2. Основное окно содержит панель инструментов (Toolbar) c левой стороны с возможностью менять ее размер за счёт рабочей области по свайпу вправо или нажатию на barItem;\n3. Toolbar содержит вкладки («Редактирование», «Просмотр», «О программе», «Выйти из аккаунта»);\n4. Во вкладке «Редактирование» в рабочей области отображается форма по добавлению, удалению и редактированию объектов (Человек) с возможностью добавления произвольных атрибутов;\n5. Во вкладке "Просмотр" в рабочей области отображается форма по просмотру введённых данных с атрибутами, при нажатии на выбранный элемент переход во вкладку «Редактировать».\n6. Данные, введённые во вкладке «Редактирование», хранятся в файле в DocumentsDirectory.
        """
        
        textView.text = string
        textView.font = UIFont.systemFont(ofSize: 20)

        view.addSubview(textView)
    }
    
    private func createConstraints() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

extension AboutAppViewController: CenterViewProtocol {
    
}
